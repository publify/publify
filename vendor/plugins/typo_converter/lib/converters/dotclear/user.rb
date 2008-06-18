module Dotclear
  class User < ActiveRecord::Base
    set_table_name 'dc_user'
    set_primary_key 'user_id'
    establish_connection configurations['dc']
    has_many :posts, :foreign_key => 'user_id', :class_name => 'Dotclear::Post'
  end
end
