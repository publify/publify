class AddUserLastConnection < ActiveRecord::Migration
  def self.up
    add_column :users, :last_connection, :datetime
  end

  def self.down
    remove_column :users, :last_connection
  end
end
