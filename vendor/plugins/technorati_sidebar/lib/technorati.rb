require 'open-uri'
require 'time'
require 'rexml/document'

class Technorati
  include REXML

  def choose(num)
    return cosmos unless cosmos.size > num
    bag = []
    set = cosmos.dup
    num.times {|x| bag << set.delete_at(rand(set.size))}
    bag
  end

  attr_accessor :url, :link, :title, :cosmos

  # This object holds given information of a picture
  class Inbound < Struct.new(:link, :title)
    def to_s; title end
  end

  def initialize(url, refresh = true)
    self.cosmos  = []
    self.url    = url
    self.refresh if refresh
  end

  # This method lets you refresh the tasks int the tasks array
  # useful if you keep the object cached in memory and
  def refresh
    open(@url) do |http|
      parse(http.read)
    end
  end

private

  def parse(body)
    xml = Document.new(body)
    self.cosmos        = []
    XPath.each(xml, "//item/") do |elem|
      inbound = Inbound.new
      inbound.title       = XPath.match(elem, "title/text()").to_s
      inbound.link        = XPath.match(elem, "link/text()").to_s
      cosmos << inbound
    end
  end
end


