class AddRememberToken < ActiveRecord::Migration
  def self.up
    add_column :users, :remember_token, :string
  end

  def self.down
    remove_column :users, :remember_token
  end
end