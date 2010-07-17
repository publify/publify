class AddsPasswordProtectionToPosts < ActiveRecord::Migration
  def self.up
    add_column :contents, :password, :string
  end

  def self.down
    remove_column :contents, :password
  end
end
