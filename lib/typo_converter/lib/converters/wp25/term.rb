module WP25
  class Term < ActiveRecord::Base
    set_table_name 'wp_terms'
    set_primary_key 'term_id'
    establish_connection configurations['wp25']

    def self.prefix=(prefix)
      set_table_name "#{prefix}_terms"
    end
  end
end
