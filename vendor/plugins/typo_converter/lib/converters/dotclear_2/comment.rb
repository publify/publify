module Dotclear2
  class Comment < ActiveRecord::Base
    establish_connection configurations['dc2']
    set_primary_key 'comment_id'
    set_table_name 'dc_comment'
    belongs_to :post, :foreign_key => 'post_id', :class_name => 'Dotclear2::Post'

    def self.prefix=(prefix)
      set_table_name "#{prefix}_comment"
    end

  end
end
