class RemoveCountCaching < ActiveRecord::Migration
  class Content < ActiveRecord::Base
    include BareMigration

    def count_children_of_type(type)
      self.class.find(:all,
                      :conditions => ["article_id = ? and type = ?",
                                                  self.id,     type]).size
    end

    def correct_counts
      self.comments_count = self.count_children_of_type('Comment')
      self.trackbacks_count = self.count_children_of_type('Trackback')
    end
  end

  def self.up
    remove_column :contents, :comments_count
    remove_column :contents, :trackbacks_count
  end

  def self.down
    modify_tables_and_update(
     [:add_column, Content, :comments_count, :integer],
     [:add_column, Content, :trackbacks_count, :integer]) do |a|
      if not $schema_generator
        a.correct_counts
      end
    end
  end
end
