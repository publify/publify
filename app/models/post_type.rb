# coding: utf-8
class PostType < ActiveRecord::Base
  validates :name, uniqueness: true
  validates :name, presence: true
  validate :name_is_not_read
  before_save :sanitize_title

  def name_is_not_read
    errors.add(:name, I18n.t('.errors.article_type_already_exist')) if name == 'read'
  end

  def sanitize_title
    self.permalink = name.to_permalink
  end
end
