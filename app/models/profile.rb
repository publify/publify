class Profile < ActiveRecord::Base
  validates_uniqueness_of :label
  has_and_belongs_to_many :rights
end
