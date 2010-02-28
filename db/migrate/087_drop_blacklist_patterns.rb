class DropBlacklistPatterns < ActiveRecord::Migration
  def self.up
    drop_table :blacklist_patterns
  end

  def self.down
    create_table :blacklist_patterns do |t|
      t.column :type, :string
      t.column :pattern, :string
    end

    add_index :blacklist_patterns, :pattern
  end
end
