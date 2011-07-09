module WP25
  class Post < ActiveRecord::Base
    set_table_name 'wp_posts'
    set_primary_key 'ID'
    establish_connection configurations['wp25']
    has_many :comments, :foreign_key => 'comment_parent', :class_name => 'WP25::Comment'
    has_many :term_relationships, :foreign_key => 'object_id'
    has_many :term_taxonomies, :through => :term_relationships,
             :class_name => 'WP25::TermTaxonomy'

    def categories
      terms_for_taxonomy 'category'
    end

    def tags
      terms_for_taxonomy 'post_tag'
    end

    def comments
      WP25::Comment.find_all_by_comment_post_ID(self.ID)
    end

    def self.prefix=(prefix)
      set_table_name "#{prefix}_posts"
    end

    private

    def terms_for_taxonomy tax
      term_taxonomies.map do |ttx|
        if ttx.taxonomy.eql?(tax)
          ttx.term.name
        end
      end.compact
    end
  end
end
