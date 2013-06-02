module WP25
  class Comment < ActiveRecord::Base
    establish_connection configurations['wp25']
    set_primary_key 'comment_ID'
    set_table_name 'wp_comments'
    belongs_to :post, :foreign_key => 'comment_parent', :class_name => 'WP25::Post'
    belongs_to :user, :class_name => 'WP25::User'

    def self.prefix=(prefix)
      set_table_name "#{prefix}_comments"
    end
  end
end
