require 'open-uri'
require 'time'
require 'rexml/document'

# Example:
#
# tada = Tada.new('http://<nick>.tadalist.com/lists/feed/<id>?token=<token>')
# tada.tasks.each do |task|
#   puts "#{task.title} @ #{task.link} updated at #{task.date}"
# end
#
class Tada
  include REXML

  attr_accessor :url, :tasks, :link, :title, :description

  # This object holds given information of a task
  class TaskItem < Struct.new(:link, :title, :date, :status)
    def to_s; title end
    def date=(value); super(Time.parse(value)) end
  end

  # Pass the url to the RSS feed you would like to keep tabs on
  # by default this will request the rss from the server right away and
  # fill the tasks array  def initialize(url, refresh = true)
  def initialize(url, refresh = true)
    self.tasks  = []
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

    self.tasks        = []
    self.link         = XPath.match(xml, "//channel/link/text()")
    self.title        = XPath.match(xml, "//channel/title/text()")
    self.description  = XPath.match(xml, "//channel/description/text()")

    XPath.each(xml, "//item/") do |elem|

      title = XPath.match(elem, "title/text()").to_s

       # extract the status from the title
       status = if title =~ /^(.+): (.+)$/
         title = $2
         $1.downcase.intern
       else
         :unknown
       end

      task = TaskItem.new
      task.title = title
      task.status = status

      task.date  = XPath.match(elem, "pubDate/text()").to_s
      task.link  = XPath.match(elem, "link/text()").to_s

      tasks << task
    end

    self.tasks = tasks.sort_by { |task| task.status.to_s }
  end
end
