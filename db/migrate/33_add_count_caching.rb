class Bare33Content < ActiveRecord::Base
  include BareMigration

  def correct_counts
    self.comments_count = self.comments_count
    self.trackbacks_count = self.trackbacks_count
  end
end


class AddCountCaching < ActiveRecord::Migration
  def self.up
    STDERR.puts "Adding comments_count, trackbacks_count"

    Bare33Content.transaction do
      add_column :contents, :comments_count, :integer
      add_column :contents, :trackbacks_count, :integer

      if not $schema_generator
        STDERR.puts "Counting comments"
        Bare33Content.reset_column_information
        Bare33Content.find(:all, :conditions => "type = 'Article'").each do |a|
          a.correct_counts
          a.save!
        end
      end
    end
  end

  def self.down
    STDERR.puts "Removing counts columns"
    Bare33Content.transaction do
      remove_column :contents, :comments_count
      remove_column :contents, :trackbacks_count
    end
  end
end

