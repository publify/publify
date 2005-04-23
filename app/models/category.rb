class Category < ActiveRecord::Base
  acts_as_list
  has_and_belongs_to_many :articles, :order => "created_at DESC"
end

