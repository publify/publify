require 'uri'
require 'net/http'

class Article < ActiveRecord::Base
  has_many :pings, :dependent => true, :order => "id DESC"
  has_many :comments, :dependent => true, :order => "id DESC"
  has_many :trackbacks, :dependent => true, :order => "id DESC"
  
  has_and_belongs_to_many :categories
  
  def stripped_title
    self.class.strip_title(title)
  end
  
  def send_pings(articleurl, urllist)
    
    # we need to transform the body now 
    # because we need to sent out an except based on the html representation
    transform_body
    
    urllist.to_a.each do |url|            
      begin
        
        ping = pings.build("url" => url)

        ping.send_ping(articleurl)               
        ping.save
        
      rescue
        # in case the remote server doesn't respond or gives an error, 
        # we should throw an xmlrpc error here.
      end      
    end
  end

  # Count articles on a certain date
  def self.count_by_date(year, month = nil, day = nil, limit = nil)  
    from, to = self.time_delta(year, month, day)
    Article.count(["created_at BETWEEN ? AND ?", from, to])
  end
  
  # Find all articles on a certain date
  def self.find_all_by_date(year, month = nil, day = nil, limit = nil)  
    from, to = self.time_delta(year, month, day)
    Article.find_all(["created_at BETWEEN ? AND ?", from, to] ,'created_at DESC', limit)
  end

  # Find one article on a certain date
  def self.find_by_date(year, month, day)  
    find_all_by_date(year, month, day).first
  end
  
  # Finds one article which was posted on a certain date and matches the supplied dashed-title
  def self.find_by_permalink(year, month, day, title)
    find_all_by_date(year, month, day).find { |a| a.stripped_title == title}
  end

  # Fulltext searches the body of published articles
  def self.search(query)
    if !query.to_s.strip.empty?
      tokens = query.split.collect {|c| "%#{c.downcase}%"}
      find_by_sql(["SELECT * from articles WHERE #{ (["LOWER(body) like ?"] * tokens.size).join(" AND ") } AND published != 0 ORDER by created_at DESC", *tokens])
    else
      []
    end
  end
  
  # Converts a post title to its-title-using-dashes
  # All special chars are stripped in the process  
  def self.strip_title(title)
    result = title.downcase

    # strip all non word chars
    result.gsub!(/\W/, ' ')

    # replace all white space sections with a dash
    result.gsub!(/\ +/, '-')

    # trim dashes
    result.gsub!(/(-)$/, '')
    result.gsub!(/^(-)/, '')
    
    result
  end

  protected  

  before_save :transform_body
  
  def transform_body
    self.body_html = HtmlEngine.transform(body, self.text_filter)
  end  

  def self.time_delta(year, month = nil, day = nil)
    from = Time.mktime(year, month || 1, day || 1)
    
    to   = from + 1.year
    to   = from + 1.month unless month.blank?    
    to   = from + 1.day   unless day.blank?

    return [from, to]
  end
end