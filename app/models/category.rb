class Category < ActiveRecord::Base
  has_and_belongs_to_many :articles, :order => "created_at DESC"
  has_many :trackbacks, :order => "created_at DESC"
end

