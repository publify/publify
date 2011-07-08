class AddUsersOptions < ActiveRecord::Migration
  class User < ActiveRecord::Base
  end

  def self.up
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :nickname, :string
    add_column :users, :url, :string
    add_column :users, :msn, :string
    add_column :users, :aim, :string
    add_column :users, :yahoo, :string
    add_column :users, :twitter, :string
    add_column :users, :description, :text
    remove_column :users, :notify_via_jabber

    unless $schema_generator
      users = User.find(:all)
      users.each do |user|
        user.nickname = user.name
        user.save!
      end
    end
  end

  def self.down
    remove_column :users, :firstname
    remove_column :users, :lastname
    remove_column :users, :nickname
    remove_column :users, :url
    remove_column :users, :msn
    remove_column :users, :aim
    remove_column :users, :jabber
    remove_column :users, :twitter
    remove_column :users, :yahoo
    remove_column :users, :description
    add_column :users, :notify_via_jabber, :tinyint
  end
end
