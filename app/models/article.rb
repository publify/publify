class Article < ActiveRecord::Base
  has_many :comments
  has_and_belongs_to_many :categories
  has_many :trackbacks
  

  def self.search(query)
    if query
      tokens      = query.split.collect {|c| "%#{c}%"}
      find_by_sql(["SELECT * from articles WHERE #{ (["body like ?"] * tokens.size).join(" AND ") }", *tokens])
    end
  end

  protected  
    before_save :transform_body
    def transform_body
      self.body_html = HtmlEngine.transform(body)
    end  
    
end
