module WP25
  class Option < ActiveRecord::Base
    set_table_name 'wp_options'
    set_primary_key 'option_id'
    establish_connection configurations['wp25']

    def self.prefix=(prefix)
      set_table_name "#{prefix}_options"
    end
  end
end
