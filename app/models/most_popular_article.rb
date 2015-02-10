class MostPopularArticle < ActiveRecord::Base
  has_and_belongs_to_many :articles

  validates :articles, length: { is: 3  }
end
