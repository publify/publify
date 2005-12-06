class AddCountCaching < ActiveRecord::Migration
  def self.up
    STDERR.puts "Adding comments_count, trackbacks_count"

    Content.transaction do
      add_column :contents, :comments_count, :integer
      add_column :contents, :trackbacks_count, :integer

      if not $schema_generator
        STDERR.puts "Counting comments"
        Article.find(:all).each do |a|
          a.send(:correct_counts)
          a.save
        end
      end
    end
  end

  def self.down
    STDERR.puts "Removing counts columns"

    drop_column :contents, :comments_count
    drop_column :contents, :trackbacks_count
  end
end
      
