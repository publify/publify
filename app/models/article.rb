class Article < ActiveRecord::Base
  has_many :comments

  def self.categories        
    articles = find_by_sql("SELECT distinct category FROM articles")
    response = articles.to_a.collect{ |a| a.category.to_a}.compact.flatten
    response
  end
  
  def self.search(query)
    tokens      = query.split
    find_by_sql(["SELECT * from articles WHERE #{ (["body like ?"] * tokens.size).join(" OR ") }", *tokens])
  end

  protected  
    before_save :transform_body
    def transform_body
      self.body_html = HtmlEngine.transform(body)
    end  
  
end
