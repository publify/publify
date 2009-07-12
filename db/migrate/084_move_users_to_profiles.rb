class MoveUsersToProfiles < ActiveRecord::Migration
  class Profile < ActiveRecord::Base
    include BareMigration

    serialize :profiles
  end

  def self.up
    Profile.find_by_label("publisher").update_attributes(:modules => [:dashboard, :write, :content, :feedback, :profile ])
    Profile.find_by_label("contributor").update_attributes(:modules => [:dashboard, :profile ])
    Profile.find_by_label("admin").update_attributes(:modules => [:dashboard, :write, :content, :feedback, :themes, :sidebar, :users, :settings, :profile])
  end

  def self.down
    Profile.find_by_label("publisher").update_attributes(:modules => [:dashboard, :write, :content, :feedback, :users ])
    Profile.find_by_label("contributor").update_attributes(:modules => [:dashboard, :users ])
    Profile.find_by_label("admin").update_attributes(:modules => [:dashboard, :write, :content, :feedback, :themes, :sidebar, :users, :settings ])
  end
end
