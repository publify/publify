class PopularArticle < ActiveRecord::Base

  has_and_belongs_to_many :articles, through: :articles

  validates :articles, length: { is: 3 }

  def self.last_or_initialize
    last || new
  end
end
