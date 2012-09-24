module Timtab
  class Post < ActiveRecord::Base
    set_table_name 'tt_news'
    set_primary_key 'uid'

    establish_connection configurations['timtab']

    has_many :comments, :foreign_key => 'external_ref', :class_name => 'Timtab::Comment'
    has_and_belongs_to_many :categories, :association_foreign_key => 'uid_foreign', :foreign_key => 'uid_local', :class_name => 'Timtab::Category', :join_table => 'tt_news_cat_mm'

    def self.inheritance_column; nil; end
  end
end