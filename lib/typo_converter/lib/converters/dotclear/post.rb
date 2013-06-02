module Dotclear
  class Post < ActiveRecord::Base
    set_table_name 'dc_post'
    set_primary_key 'post_id'
    establish_connection configurations['dc']
    has_many :comments, :foreign_key => 'post_id', :class_name => 'Dotclear::Comment'
    belongs_to :categorie, :foreign_key => 'cat_id', :class_name => 'Dotclear::Category'
  end
end
