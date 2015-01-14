class PopularArticle < ActiveRecord::Base

  has_and_belongs_to_many :articles, through: :articles

  validate :articles, :validate_popular_article_max
  validate :articles, :validate_popular_article_min

  def validate_popular_article_max
    if self.articles.size > 3
      errors.add(:article_ids, 'Max popular article limit reached')
    end
  end

  def validate_popular_article_min
    if self.articles.size < 3
      errors.add(:article_ids, 'At least 3 articles are required')
    end
  end
end
