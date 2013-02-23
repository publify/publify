# coding: utf-8
class PostType < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name
  validate :name_is_not_read
  before_save :sanitize_title
  
  def name_is_not_read
      errors.add(:name, _("This article type already exists")) if name == 'read'
  end
  
  def sanitize_title
    self.permalink = self.name.to_permalink
  end

end
