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
      term_taxonomies.inject([]) do |list, taxonomy|
        if taxonomy.taxonomy.eql?('category')
          list << taxonomy.term.name
        end
        list
      end
    end

    def tags
      term_taxonomies.inject([]) do |list, taxonomy|
        if taxonomy.taxonomy.eql?('post_tag')
          list << taxonomy.term.name
        end
        list
      end
    end

    def comments
      WP25::Comment.find_all_by_comment_post_ID(self.ID)
    end
    
    def self.prefix=(prefix)
      set_table_name "#{prefix}_posts"
    end
  end
end
