require 'open-uri'
require 'time'
require 'rexml/document'

# Example:
# 
# flickr = Flickr.new('http://www.flickr.com/services/feeds/photos_public.gne?id=40235412@N00&format=rss_200')
# flickr.pics.each do |pic|
#   puts "#{pic.title} @ #{pic.link} updated at #{pic.date}"
# end
#
class FlickrAggregation
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
    attr_accessor :link, :title, :date, :description

    def to_s
      title
    end

    def date=(value)
      @date = Time.parse(value)
    end

    def image 
      description.scan( /(http:\/\/(static|photos).*\.jpg)/ ).first.first
    end
    def thumb
      image.gsub( /\_m\./, '_t.' )
    end
    def square
      image.gsub( /\_m\./, '_s.' )
    end
  end
    
  # Pass the url to the RSS feed you would like to keep tabs on
  # by default this will request the rss from the server right away and 
  # fill the tasks array
  def initialize(url, refresh = true)
    self.pics  = []
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
      
      pics << picture
    end
  end
end


