class AddUsersDisplayPerms < ActiveRecord::Migration
  def self.up
    add_column :users, :show_url, :boolean
    add_column :users, :show_msn, :boolean
    add_column :users, :show_aim, :boolean
    add_column :users, :show_yahoo, :boolean
    add_column :users, :show_twitter, :boolean
    add_column :users, :show_jabber, :boolean
  end

  def self.down
    remove_column :users, :show_url
    remove_column :users, :show_msn
    remove_column :users, :show_aim
    remove_column :users, :show_yahoo
    remove_column :users, :show_twitter
    remove_column :users, :show_jabber
  end
end
