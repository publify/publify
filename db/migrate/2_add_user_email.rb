class AddUserEmail < ActiveRecord::Migration
  class BareUser < ActiveRecord::Base
    include BareMigration
  end

  def self.up
    modify_tables_and_update([:add_column, BareUser, :email, :text],
                             [:add_column, BareUser, :name,  :text]) do |u|
      u.name = u.login
    end
  end

  def self.down
    remove_column :users, :email
    remove_column :users, :name
  end
end
