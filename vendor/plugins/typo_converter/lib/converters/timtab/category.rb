module Timtab
  class Category < ActiveRecord::Base
    set_table_name 'tt_news_cat'
    set_primary_key 'uid'

    establish_connection configurations['timtab']

    has_and_belongs_to_many :posts, :association_foreign_key => 'uid_local', :foreign_key => 'uid_foreign', :class_name => 'Timtab::Post', :join_table => 'tt_news_cat_mm'
  end
end