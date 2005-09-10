require 'uri'
require 'net/http'

class Article < ActiveRecord::Base
  include TypoGuid
  
  has_many :pings, :dependent => true, :order => "created_at ASC"
  has_many :comments, :dependent => true, :order => "created_at ASC"
  has_many :trackbacks, :dependent => true, :order => "created_at ASC"
  has_many :resources, :order => "created_at DESC"
  
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :tags
  belongs_to :user
  belongs_to :text_filter
  
  after_destroy :fix_resources
  
  # Compatibility hack, so Article.attributes(params[:article]) still works.
  def text_filter=(filter)
    if filter.nil?
      self.text_filter_id = nil
    elsif filter.kind_of? TextFilter
      self.text_filter_id = filter.id
    else
      new_filter = TextFilter.find_by_name(filter.to_s)
      self.text_filter_id = (new_filter.nil? ? nil : new_filter.id)
    end
  end
  
  def stripped_title
    self.title.to_url
  end
  
  def html(controller,what = :all)
    if(self.body_html.blank?)
      self.body_html = controller.filter_text_by_name(body, text_filter.name) rescue body.to_s
      self.extended_html = controller.filter_text_by_name(extended, text_filter.name) rescue extended.to_s
      save if self.id
    end
    
    case what
    when :all
      body_html+"\n"+extended_html.to_s
    when :body
      body_html
    when :extended
      extended_html.to_s
    else
      raise "Unknown 'what' in article.html"
    end
  end
  
  def html_urls
    urls = Array.new
    
    (body_html.to_s + extended_html.to_s).gsub(/<a [^>]*>/) do |tag|
      if(tag =~ /href="([^"]+)"/)
        urls.push($1)
      end
    end
    
    urls
  end
  
  def send_pings(articleurl, urllist)
    return unless config[:send_outbound_pings]
    
    ping_urls = config[:ping_urls].gsub(/ +/,'').split(/[\n\r]+/)
    ping_urls += self.html_urls
    ping_urls += urllist.to_a
    
    ping_urls.uniq.each do |url|            
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
    Article.count(["#{Article.table_name}.created_at BETWEEN ? AND ? AND #{Article.table_name}.published != 0", from, to])
  end
  
  # Find all articles on a certain date
  def self.find_all_by_date(year, month = nil, day = nil)
    from, to = self.time_delta(year, month, day)
    Article.find(:all, :conditions => ["#{Article.table_name}.created_at BETWEEN ? AND ? AND #{Article.table_name}.published != 0", from, to], :order => "#{Article.table_name}.created_at DESC")
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
      AND #{Article.table_name}.created_at BETWEEN ? AND ?
      AND #{Article.table_name}.published != 0
    }, title, from, to ])
  end
  
  def self.find_published_by_category_permalink(category_permalink, options = {})
    category = Category.find_by_permalink(category_permalink)
    return [] unless category
    
    Article.find(:all, 
      { :conditions => [%{ published != 0 
        AND #{Article.table_name}.id = articles_categories.article_id
        AND articles_categories.category_id = ? }, category.id], 
      :joins => ", #{Article.table_name_prefix}articles_categories#{Article.table_name_suffix} articles_categories",
      :order => "created_at DESC"}.merge(options))
  end

  def self.find_published_by_tag_name(tag_name, options = {})
    tag = Tag.find_by_name(tag_name)
    return [] unless tag

    Article.find(:all, 
      { :conditions => [%{ published != 0 
        AND #{Article.table_name}.id = articles_tags.article_id
        AND articles_tags.tag_id = ? }, tag.id], 
      :joins => ", #{Article.table_name_prefix}articles_tags#{Article.table_name_suffix} articles_tags",
      :order => "created_at DESC"}.merge(options))
  end

  # Fulltext searches the body of published articles
  def self.search(query)
    if !query.to_s.strip.empty?
      tokens = query.split.collect {|c| "%#{c.downcase}%"}
      find_by_sql(["SELECT * FROM #{Article.table_name} WHERE #{Article.table_name}.published != 0 AND #{ (["(LOWER(body) LIKE ? OR LOWER(extended) LIKE ? OR LOWER(title) LIKE ?)"] * tokens.size).join(" AND ") } AND published != 0 ORDER by created_at DESC", *tokens.collect { |token| [token] * 3 }.flatten])
    else
      []
    end
  end
  
  def keywords_to_tags
    Article.transaction do
      tags.clear
      keywords.to_s.split.uniq.each do |tagword|
        tags << Tag.get(tagword)
      end
    end
  end
  
  protected  

  before_save :set_defaults, :create_guid
  
  def set_defaults
    begin
      schema_info=Article.connection.select_one("select * from schema_info limit 1")
      schema_version=schema_info["version"].to_i
    rescue
      # The test DB doesn't currently support schema_info.
      schema_version=10
    end

    self.published ||= 1
    
    if schema_version >= 7
      self.permalink = self.stripped_title if self.attributes.include?("permalink") and self.permalink.blank?
    end

    if schema_version >= 10
      keywords_to_tags
    end

    if schema_version >= 13
      self.text_filter = TextFilter.find_by_name(config['text_filter']) if self.text_filter_id.blank?
    end
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

  private
  def fix_resources
    Resource.find(:all, :conditions => "article_id = #{id}").each do |fu|
      fu.article_id = nil
      fu.save
    end
  end
end
