class AddsStatusesRules < ActiveRecord::Migration
  class Profile < ActiveRecord::Base
    include BareMigration

    serialize :profiles
  end

  def self.up
    say "Adds new statuses rules to existing profiles"

    Profile.find_by_label("admin").try :update_attributes,
      modules: [:dashboard, :articles, :statuses, :pages, :feedback, :media, :themes, :sidebar, :profile, :users, :settings, :seo, ]
    Profile.find_by_label("publisher").try :update_attributes,
      modules: [:dashboard, :articles, :statuses, :pages, :feedback, :media, :profile]
  end

  def self.down
    say "Merges pages and articles to content"

    Profile.find_by_label("admin").try :update_attributes,
      modules: [:dashboard, :articles, :pages, :media, :feedback, :themes, :sidebar, :users, :settings, :profile, :seo]
    Profile.find_by_label("publisher").try :update_attributes,
      modules: [:dashboard, :write, :content, :feedback, :profile]
  end
end
