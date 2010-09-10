module Dotclear2
  class Post < ActiveRecord::Base
    set_table_name 'dc_post'
    set_primary_key 'post_id'
    establish_connection configurations['dc2']
    has_many :comments, :foreign_key => 'post_id', :class_name => 'Dotclear2::Comment'
    has_many :tags, :foreign_key => 'post_id', :class_name => 'Dotclear2::Tag'
    belongs_to :categorie, :foreign_key => 'cat_id', :class_name => 'Dotclear2::Category'

    def self.prefix=(prefix)
      set_table_name "#{prefix}_post"
    end

  end
end
