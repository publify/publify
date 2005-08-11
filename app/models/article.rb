require 'uri'
require 'net/http'
require 'md5'

class Article < ActiveRecord::Base
  has_many :pings, :dependent => true, :order => "created_at ASC"
  has_many :comments, :dependent => true, :order => "created_at ASC"
  has_many :trackbacks, :dependent => true, :order => "created_at ASC"
  
  has_and_belongs_to_many :categories
  belongs_to :user
  
  def stripped_title
    self.title.to_url
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
    Article.count(["articles.created_at BETWEEN ? AND ? AND articles.published != 0", from, to])
  end
  
  # Find all articles on a certain date
  def self.find_all_by_date(year, month = nil, day = nil)
    from, to = self.time_delta(year, month, day)
    Article.find(:all, :conditions => ["articles.created_at BETWEEN ? AND ? AND articles.published != 0", from, to], :order => 'articles.created_at DESC', :include => [:categories, :trackbacks, :comments])
  end

  # Find one article on a certain date
  def self.find_by_date(year, month, day)  
    find_all_by_date(year, month, day).first
  end
  
  # Finds one article which was posted on a certain date and matches the supplied dashed-title
  def self.find_by_permalink(year, month, day, title)
    from, to = self.time_delta(year, month, day)
    find(:first, :conditions => [ %{
      permalink = ?
      AND articles.created_at BETWEEN ? AND ?
      AND articles.published != 0
    }, title, from, to ])
  end

  # Fulltext searches the body of published articles
  def self.search(query)
    if !query.to_s.strip.empty?
      tokens = query.split.collect {|c| "%#{c.downcase}%"}
      find_by_sql(["SELECT * from articles WHERE articles.published != 0 AND #{ (["(LOWER(body) LIKE ? OR LOWER(extended) LIKE ? OR LOWER(title) LIKE ?)"] * tokens.size).join(" AND ") } AND published != 0 ORDER by created_at DESC", *tokens.collect { |token| [token] * 3 }.flatten])
    else
      []
    end
  end
  
  # Get the full html body
  def full_html
    "#{body_html}\n\n#{extended_html}"
  end
  
  protected  

  before_save :set_defaults, :transform_body
  
  def set_defaults
    self.published ||= 1
    self.text_filter = config['text_filter'] if self.text_filter.blank?
    self.permalink = self.stripped_title if self.attributes.include?("permalink") and self.permalink.blank?
    self.guid = Digest::MD5.new(self.body.to_s+self.extended.to_s+self.title.to_s+self.permalink.to_s+self.author.to_s+Time.now.to_f.to_s).to_s if self.guid.blank?
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
    to   = to.tomorrow    unless month.blank?
    return [from, to]
  end

  validates_uniqueness_of :guid
  validates_presence_of :title
end
