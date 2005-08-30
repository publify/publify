class Tag < ActiveRecord::Base
  has_and_belongs_to_many :articles
  validates_uniqueness_of :name

  def self.get(name)
    tag = find_by_name(name)
    if(not tag)
      tag=Tag.create(:name => name)
    end

    return tag
  end

  def self.find_all_with_article_counters
    self.find_by_sql(%{
      SELECT id, name, COUNT(article_id) AS article_counter
      FROM #{Tag.table_name} tags LEFT OUTER JOIN #{Tag.table_name_prefix}articles_tags#{Tag.table_name_suffix} articles_tags
        ON articles_tags.tag_id = tags.id
      GROUP BY tags.id, tags.name
      ORDER BY UPPER(name)
      })
  end

end
