class AddModulesToProfile < ActiveRecord::Migration
  class Profile < ActiveRecord::Base
    include BareMigration

    serialize :profiles
  end

  def self.up
    add_column :profiles, :modules, :text

    Profile.find_by_label("admin").update_attributes(:modules => [:dashboard, :write, :content, :feedback, :themes, :sidebar, :users, :settings])
    Profile.find_by_label("publisher").update_attributes(:modules => [:dashboard, :write, :content, :feedback ])
  end

  def self.down
    remove_column :profiles, :modules
  end
end
