class Article < ActiveRecord::Base
  publishable
  converts_to_html :body
  
  def self.categories        
    articles = find_by_sql("SELECT distinct category FROM articles")
    response = articles.to_a.collect{ |a| a.category.to_a}.compact.flatten
    response
  end
  
end
