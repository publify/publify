class AddsSeoToProfiles < ActiveRecord::Migration
  class Profile < ActiveRecord::Base
    include BareMigration

    serialize :profiles
  end

  def self.up
    STDERR.puts "Adding the seo module to admin profile"
    Profile.find_by_label("admin").update_attributes(:modules => [:dashboard, :write, :content, :feedback, :themes, :sidebar, :users, :settings, :profile, :seo])
  end

  def self.down
    STDERR.puts "Removing the seo module to admin profile"
    Profile.find_by_label("admin").update_attributes(:modules => [:dashboard, :write, :content, :feedback, :themes, :sidebar, :users, :settings, :seo ])
  end
end
