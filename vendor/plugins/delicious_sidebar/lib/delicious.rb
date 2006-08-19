require 'open-uri'
require 'time'
require 'rexml/document'

class Delicious
  include REXML

  attr_accessor :url, :items, :link, :title, :days

  # This object holds given information of an item
  class DeliciousItem < Struct.new(:link, :title, :description, :description_link, :date)
    def to_s; title end
  end

  # Pass the url to the RSS feed you would like to keep tabs on
  # by default this will request the rss from the server right away and
  # fill the items array
  def initialize(url, refresh = true)
    self.items  = []
    self.url    = url
    self.days   = {}
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
    self.link         = XPath.match(xml, "//channel/link/text()").first.value rescue ""
    self.title        = XPath.match(xml, "//channel/title/text()").first.value rescue ""

    XPath.each(xml, "//item/") do |elem|
      item = DeliciousItem.new
      item.title       = XPath.match(elem, "title/text()").first.value rescue ""
      item.link        = XPath.match(elem, "link/text()").first.value rescue ""
      item.description = XPath.match(elem, "description/text()").first.value rescue ""
      item.date        = Time.mktime(*ParseDate.parsedate(XPath.match(elem, "dc:date/text()").first.value)) rescue Time.now

      item.description_link = item.description
      item.description.gsub!(/<\/?a\b.*?>/, "") # remove all <a> tags
      items << item
    end

    self.items = items.sort_by { |item| item.date }.reverse
  end
end
