module WP25
  class TermTaxonomy < ActiveRecord::Base
    set_table_name 'wp_term_taxonomy'
    set_primary_key 'term_taxonomy_id'
    establish_connection configurations['wp25']

    has_many :term_relationships, :foreign_key => 'term_taxonomy_id'
    has_many :posts, :through => :term_relationships,
             :class_name => 'WP25:Post'

    def term
      WP25::Term.find_by_term_id(term_id)
    end

    def self.prefix=(prefix)
      set_table_name "#{prefix}_term_taxonomy"
    end
  end
end
