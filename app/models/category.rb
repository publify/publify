class Category < ActiveRecord::Base
  acts_as_list
  has_and_belongs_to_many :articles, :order => "created_at DESC"
  
  def self.find_all_with_article_counters
    self.find_by_sql(%{
      SELECT id, name, position, COUNT(article_id) AS article_counter
      FROM categories LEFT OUTER JOIN articles_categories 
        ON articles_categories.category_id = categories.id
      GROUP BY categories.id, categories.name, categories.position
      ORDER BY position, name
      })
  end
end

