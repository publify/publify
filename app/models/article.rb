require 'uri'
require 'net/http'

class Article < ActiveRecord::Base
  has_many :pings, :dependent => true, :order => "created_at ASC"
  has_many :comments, :dependent => true, :order => "created_at ASC"
  has_many :trackbacks, :dependent => true, :order => "created_at ASC"
  
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
        unless pings.collect { |p| p.url }.include?(url.strip) 
          ping = pings.build("url" => url)

          ping.send_ping(articleurl)               
          ping.save
        end
        
      rescue
        # in case the remote server doesn't respond or gives an error, 
        # we should throw an xmlrpc error here.
      end      
    end
  end

  # Count articles on a certain date
  def self.count_by_date(year, month = nil, day = nil, limit = nil)  
    from, to = self.time_delta(year, month, day)
    Article.count(["articles.created_at BETWEEN ? AND ?", from, to])
  end
  
  # Find all articles on a certain date
  def self.find_all_by_date(year, month = nil, day = nil, limit = nil)  
    from, to = self.time_delta(year, month, day)
    Article.find(:all, :conditions => ["articles.created_at BETWEEN ? AND ?", from, to], :order => 'articles.created_at DESC', :limit => limit, :include => [:categories, :trackbacks, :comments])
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
      find_by_sql(["SELECT * from articles WHERE #{ (["(LOWER(body) LIKE ? OR LOWER(extended) LIKE ? OR LOWER(title) LIKE ?)"] * tokens.size).join(" AND ") } AND published != 0 ORDER by created_at DESC", *tokens.collect { |token| [token] * 3 }.flatten])
    else
      []
    end
  end
  
  # Converts a post title to its-title-using-dashes
  # All special chars are stripped in the process  
  def self.strip_title(title)
    result = title.downcase

    # replace quotes by nothing
    result.gsub!(/['"]/, '')

    # strip all non word chars
    result.gsub!(/\W/, ' ')

    # replace all white space sections with a dash
    result.gsub!(/\ +/, '-')

    # trim dashes
    result.gsub!(/(-)$/, '')
    result.gsub!(/^(-)/, '')
    
    result
  end
  
  # Does this article have a extended entry?
  def has_extended?
    extended_html.size > 0
  end
  
  protected  

  before_save :transform_body, :set_defaults
  
  def set_defaults
    self.published ||= 1
  end
  
  def transform_body
    self.body_html = HtmlEngine.transform(body, self.text_filter)
    self.extended_html = HtmlEngine.transform(extended, self.text_filter)
  end  

  def self.time_delta(year, month = nil, day = nil)
    from = Time.mktime(year, month || 1, day || 1)
    
    to   = from + 1.year
    to   = from + 1.month unless month.blank?    
    to   = from + 1.day   unless day.blank?

    return [from, to]
  end
end