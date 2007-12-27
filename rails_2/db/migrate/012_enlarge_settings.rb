class EnlargeSettings < ActiveRecord::Migration
  def self.up
    change_column :settings, :name, :string, :limit => 255
    change_column :settings, :value, :string, :limit => 255
  end

  def self.down
    change_column :settings, :name, :string, :limit => 40
    change_column :settings, :value, :string, :limit => 40
  end
end
