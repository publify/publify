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
  # task.title => "My tada task"
  # task.date => "2005-01-19..."
  # task.link => "http://..."
  class Task < Struct.new(:link, :title, :date, :status)
    def to_s; title end          
    def date=(value); super(Time.parse(value)) end
  end
    
  # Pass the url to the tada RSS feed you would like to keep tabs on
  # by default this will request the rss from the tada server right away and 
  # fill the tasks array
  def initialize(url, refresh = true)
    self.tasks  = []
    self.url    = url
    self.refresh if refresh
  end
  
  # This method lets you refresh the tasks int the tasks array
  # useful if you keep the tada object cached in memory and 
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

      task = Task.new
      task.title = title
      task.status = status
                  
      task.date  = XPath.match(elem, "pubDate/text()").to_s
      task.link  = XPath.match(elem, "link/text()").to_s
      
      tasks << task
    end
  end
end


