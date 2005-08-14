class Category < ActiveRecord::Base
  acts_as_list
  has_and_belongs_to_many :articles, :order => "created_at DESC"
  
  def self.find_all_with_article_counters
    self.find_by_sql(%{
      SELECT id, name, permalink, position, COUNT(article_id) AS article_counter
      FROM categories LEFT OUTER JOIN articles_categories 
        ON articles_categories.category_id = categories.id
      GROUP BY categories.id, categories.name, categories.position, categories.permalink
      ORDER BY name
      })
  end
  
  def stripped_name
    self.name.to_url
  end
  
  protected  
  
  before_save :set_defaults
  
  def set_defaults
    self.permalink ||= self.stripped_name
  end
  
  validates_presence_of :name
  validates_uniqueness_of :name, :on => :create
end

