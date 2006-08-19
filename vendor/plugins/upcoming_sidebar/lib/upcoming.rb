require 'open-uri'
require 'rexml/document'

# Example:
#
# upcoming = Upcoming.new('http://upcoming.org/syndicate/my_events/<your_user_id>')
# upcoming.events.each do |event|
#   puts "#{event.title} @  #{event.timespan} #{event.link} : #{event.description}"
# end
#

class Upcoming
  include REXML

  def choose(num)
    events.last(num)
  end

  attr_accessor :events, :link, :title, :description, :url

  # This object holds given information for an Event
  class Event < Struct.new(:link, :title, :description)
    def to_s; title end

    def timespan
      description.split(':')[0]
    end

    def info
        description.split(':')[1]
    end
  end

  # Pass the url to the RSS feed you would like to keep tabs on
  # by default this will request the rss from the server right away and
  # fill the tasks array
  def initialize(url, refresh = true)
    self.events  = []
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

    self.events       = []
    self.link         = XPath.match(xml, "//channel/link/text()").to_s
    self.title        = XPath.match(xml, "//channel/title/text()").to_s
    self.description  = XPath.match(xml, "//channel/description/text()").to_s

    XPath.each(xml, "//item/") do |elem|

      event = Event.new
      event.title       = XPath.match(elem, "title/text()").to_s
      event.link        = XPath.match(elem, "link/text()").to_s
      event.description = XPath.match(elem, "description/text()").to_s
      event.inspect
      events << event
    end
  end
end


