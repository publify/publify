require 'open-uri'
require 'time'
require 'rexml/document'

# Example:
#                                                                            
# magnolia = MagnoliaAggregation.new('http://ma.gnolia.com/rss/full/people/steve.longdo/')
# magnolia.pics.each do |pic|
#   puts "#{pic.title} @ #{pic.link} updated at #{pic.date}"
# end
#
class MagnoliaAggregation
  include REXML

  def choose(num)
    return pics unless pics.size > num
    bag = []
    set = pics.dup
    (0..num-1).each {|x| bag << set.delete_at(rand(set.size))}
    bag
  end

  attr_accessor :url, :pics, :link, :title, :description

  # This object holds given information of a picture
  class Picture
    attr_accessor :link, :title, :date, :description, :image

    def to_s
      title
    end

    def date=(value)
      @date = Time.parse(value)
    end

    def image
      begin
        CGI.unescapeHTML(description.scan( /(http:\/\/(scst.srv.girafa.com).*\")/ ).first.first).chomp('"')
      rescue Exception => e
        p e
        nil
      end
    end
  end

  def initialize(url, refresh = true)
    self.pics  = []
    self.url    = url
    self.refresh if refresh
  end

  def refresh
    open(@url) do |http|
      parse(http.read)
    end
  end

private

  def parse(body)
# Not checking filesize here yet. Just looking for the not found condition...
    xml = Document.new(body)

    self.pics        = []
    self.link         = XPath.match(xml, "//channel/link/text()").to_s
    self.title        = XPath.match(xml, "//channel/title/text()").to_s
    self.description  = XPath.match(xml, "//channel/description/text()").to_s

     XPath.each(xml, "//item/") do |elem|
       picture = Picture.new
       picture.title       = XPath.match(elem, "title/text()").to_s
       picture.date        = XPath.match(elem, "pubDate/text()").to_s
       picture.link        = XPath.match(elem, "link/text()").to_s
       picture.description = XPath.match(elem, "description/text()").to_s       
       pics << picture unless picture.image.nil? || picture.image.match(/not found/)
     end
  end
end


