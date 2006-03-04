class Bare2User < ActiveRecord::Base
  include BareMigration
end

class AddUserEmail < ActiveRecord::Migration
  def self.up
    Bare2User.transaction do
      add_column :users, :email, :text
      add_column :users, :name, :text
  
      Bare2User.reset_column_information
      Bare2User.find(:all).each do |u|
        u.name=u.login
        # why blank out all the paswords??
        u.password = ''
        u.save!
      end
    end
  end

  def self.down
    Bare2User.transaction do
      remove_column :users, :email
      remove_column :users, :name
    end
  end
end
