class Article < ActiveRecord::Base
  has_many :comments
  has_and_belongs_to_many :categories
  has_many :trackbacks
  
  def stripped_title
    self.class.strip_title(title)
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
      tokens      = query.split.collect {|c| "%#{c}%"}
      find_by_sql(["SELECT * from articles WHERE #{ (["body like ?"] * tokens.size).join(" AND ") }", *tokens])
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
