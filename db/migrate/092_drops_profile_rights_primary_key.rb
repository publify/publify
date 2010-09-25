class DropsProfileRightsPrimaryKey < ActiveRecord::Migration
  def self.up
    remove_column :profiles_rights, :id
  end

  def self.down
    add_column :profiles_rights, :id, :integer
  end
end
