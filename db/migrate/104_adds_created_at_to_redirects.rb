class AddsCreatedAtToRedirects < ActiveRecord::Migration

  def self.up
    add_column :redirects, :created_at, :datetime
    add_column :redirects, :updated_at, :datetime
    
  end

  def self.down
    remove_column :redirects, :created_at
    remove_column :redirects, :updated_at
  end
end

