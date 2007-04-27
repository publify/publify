require 'open-uri'
require 'time'
require 'rexml/document'

class Audioscrobbler
  include REXML

  attr_accessor :url, :items, :link, :artist, :title

  # This object holds given information of an item
  class AudioscrobblerItem < Struct.new(:link, :artist, :title, :date)
    def to_s; title end
  end

  # Pass the url to the RSS feed you would like to keep tabs on
  # by default this will request the rss from the server right away and
  # fill the items array
  def initialize(url, refresh = true)
	self.items  = []
	self.url    = url
	self.refresh if refresh
  end

  # This method lets you refresh the items in the items array
  # useful if you keep the object cached in memory and
  def refresh
    open(@url) do |http|
      parse(http.read)
    end
  end

  private

  def parse(body)

    xml = Document.new(body)

    self.items        = []
    self.link         = XPath.match(xml, "//channel/link/text()").to_s
    self.title        = XPath.match(xml, "//channel/title/text()").to_s

    XPath.each(xml, "//item/") do |elem|

      item = AudioscrobblerItem.new
      item.title       = XPath.match(elem, "dc:title/text()").to_s
      item.artist       = XPath.match(elem, "mm:Artist/dc:creator/dc:title/text()").to_s
      item.link        = XPath.match(elem, "link/text()").to_s
      item.date        = Time.mktime(*ParseDate.parsedate(XPath.match(elem, "dc:date/text()").to_s))
      items << item
    end

    self.items = items.sort_by { |item| item.date }.reverse
  end
end
