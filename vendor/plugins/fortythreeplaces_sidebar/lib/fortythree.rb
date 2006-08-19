require 'open-uri'
require 'time'
require 'rexml/document'

# Example:
#
# fortythree = Fortythree.new('http://www.43things.com/rss/uber/author?username=<user>')
# fortythree.things.each do |thing|
#   puts "#{thing.title} @ #{thing.link} updated at #{thing.date}"
# end
#
class Fortythree
  include REXML

  attr_accessor :url, :things, :link, :title, :description

  # This object holds given information of a thing
  class ThingItem < Struct.new(:link, :title, :date)
    def to_s; title end
    def date=(value); super(Time.parse(value)) end
  end

  # Pass the url to the RSS feed you would like to keep tabs on
  # by default this will request the rss from the server right away and
  # fill the tasks array  def initialize(url, refresh = true)
  def initialize(url, refresh = true)
    self.things  = []
    self.url    = url
    self.refresh if refresh
  end

  # This method lets you refresh the things into the things array
  # useful if you keep the object cached in memory and
  def refresh
    open(@url) do |http|
      parse(http.read)
    end
  end

private

  def parse(body)

    xml = Document.new(body)

    self.things        = []
    self.link         = XPath.match(xml, "//channel/link/text()").to_s
    self.title        = XPath.match(xml, "//channel/title/text()").to_s
    self.description  = XPath.match(xml, "//channel/description/text()").to_s

    XPath.each(xml, "//item/") do |elem|

      thing = ThingItem.new
      thing.title = XPath.match(elem, "title/text()").to_s

      thing.date  = XPath.match(elem, "pubDate/text()").to_s
      thing.link  = XPath.match(elem, "link/text()").to_s

      things << thing
    end
  end
end
