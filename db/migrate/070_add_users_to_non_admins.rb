class AddUsersToNonAdmins < ActiveRecord::Migration
  class Profile < ActiveRecord::Base
    include BareMigration

    serialize :profiles
  end

  def self.up
    Profile.find_by_label("publisher").update_attributes(:modules => [:dashboard, :write, :content, :feedback, :users ])
    Profile.find_by_label("contributor").update_attributes(:modules => [:dashboard, :users ])
  end

  def self.down
    Profile.find_by_label("publisher").update_attributes(:modules => [:dashboard, :write, :content, :feedback ])
    Profile.find_by_label("contributor").update_attributes(:modules => [])
  end
end
