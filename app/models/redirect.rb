class Redirect < ActiveRecord::Base
  validates_uniqueness_of :from_path
  validates_presence_of :from_path
  validates_presence_of :to_path
end
