class Bare33Content < ActiveRecord::Base
  include BareMigration

  def count_children_of_type(type)
    self.class.find(:all,
                    :conditions => ["article_id = ? and type = ?",
                                               self.id,       type ]).size
  end

  def correct_counts
    self.comments_count   = self.count_children_of_type('Comment')
    self.trackbacks_count = self.count_children_of_type('Trackback')
  end
end


class AddCountCaching < ActiveRecord::Migration
  def self.up
    say "Adding comments_count, trackbacks_count"
    modify_tables_and_update([:add_column, Bare33Content, :comments_count, :integer],
                             [:add_column, Bare33Content, :trackbacks_count, :integer]) do |a|
      if not $schema_generator
        a.correct_counts
      end
    end
  end

  def self.down
    say "Removing counts columns"
    remove_column :contents, :comments_count
    remove_column :contents, :trackbacks_count
  end
end

