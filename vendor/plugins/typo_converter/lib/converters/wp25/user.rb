module WP25
  class User < ActiveRecord::Base
    set_table_name 'wp_users'
    set_primary_key 'ID'
    establish_connection configurations['wp25']
    has_many :posts, :foreign_key => 'post_author', :class_name => 'WordPress::Post'

    def self.prefix=(prefix)
      set_table_name "#{prefix}_users"
    end
  end
end
