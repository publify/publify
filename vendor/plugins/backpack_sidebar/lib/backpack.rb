require 'backpack_api'
require 'redcloth'

# Example:
#
# backpack = Backpack.new('<nick>', '<token>'[, '<page id>'])
# backpack.items.each do |item|
#   puts "#{item.title} @ #{item.link} updated at #{item.date}"
# end
#
class Backpack
  attr_accessor :username, :token, :page_id, :items, :title

  # This object holds given information of an item
  class BackpackItem < Struct.new(:completed, :id, :content)
    def to_s
      # Use REXML::Text#value as a workaround for entity decoding
      RedCloth.new(REXML::Text.new(self.content).value).to_html(:textile).gsub(/^<p>|<\/p>$/, '')
    end
  end

  # Pass the username, token, and page id for the Backpack page
  # you wish to view the list items for.
  # By default this will request the items right away
  def initialize(username, token, page_id, refresh = true)
    @items    = []
    @username = username
    @token    = token
    @page_id  = page_id
    @title    = ''
    self.refresh if refresh
  end

  # This method lets you refresh the items in the items array
  # useful if you keep the object cached in memory and
  def refresh
    bp = BackpackAPI.new(@username, @token)
    begin
      page = bp.show_page(@page_id)['page'].first
    rescue
      # Exception occurs if @page_id isn't valid
      @items = []
      @title = ''
    else
      @items = parse(page['items'].first)
      @title = page['title']
    end
  end

  private

  def parse(result)
    result['item'].collect do |item|
      BackpackItem.new((item['completed'] == 'true'), item['id'], item['content'])
    end
  end
end
