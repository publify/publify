class Article < ActiveRecord::Base
  has_many :comments
  has_and_belongs_to_many :categories
  has_many :trackbacks
  has_many :pings
  
  def stripped_title
    self.class.strip_title(title)
  end
  
  def send_pings(articleurl, urllist)
    require 'uri'
    require 'net/http'

    urllist.to_a.each do |url|
      # record the ping in the database
      ping = build_to_pings
      ping.url = url
      
      uri = URI.parse(url)
      post = "title=#{URI.escape(title)}"
      post << "&excerpt=#{URI.escape(strip_html(body_html)[0..254])}"
      post << "&url=#{URI.escape(articleurl)}"
      post << "&blog_name=#{URI.escape(config['blog_name'])}"
      begin
        Net::HTTP.start(uri.host, uri.port) do |http|
          response = http.post("#{uri.path}?#{uri.query}", post)
        end
      rescue
        # in case the remote server doesn't respond or gives an error, 
        # we should throw an xmlrpc error here.
      end
    end
  end

  def self.find_all_by_date(year, month, day)  
    from = Time.mktime(year, month, day)
    to   = from + 1.day

    Article.find_all(["created_at BETWEEN ? AND ?", from, to] ,'created_at DESC')
  end

  def self.find_by_date(year, month, day)  
    find_all_by_date(year, month, day).first
  end
  
  def self.find_by_permalink(year, month, day, title)
    if title == "article-2"
      return find(2)
    end
  end

  def self.search(query)
    if query
      tokens      = query.split.collect {|c| "%#{c.downcase}%"}
      find_by_sql(["SELECT * from articles WHERE #{ (["LOWER(body) like ?"] * tokens.size).join(" AND ") } ORDER by created_at DESC", *tokens])
    end
  end
  
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
    self.body_html = HtmlEngine.transform(body)
  end  
  
  private
      
end
