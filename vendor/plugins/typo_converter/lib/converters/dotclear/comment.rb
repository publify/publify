module Dotclear
  class Comment < ActiveRecord::Base
    establish_connection configurations['dc']
    set_primary_key 'comment_id'
    set_table_name 'dc_comment'
    belongs_to :post, :foreign_key => 'post_id', :class_name => 'Dotclear::Post'
  end
end
