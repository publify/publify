class FixContentsPublishedDefault < ActiveRecord::Migration
  def self.up
    change_column :contents, :published, :boolean, :default => false
  end

  def self.down
    change_column :contents, :published, :boolean, :default => true
  end
end
