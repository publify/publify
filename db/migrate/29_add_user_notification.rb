class Bare29User < ActiveRecord::Base
  include BareMigration
end

class AddUserNotification < ActiveRecord::Migration
  def self.up
    Bare29User.transaction do
      add_column :users, :notify_via_email, :boolean
      add_column :users, :notify_on_new_articles, :boolean
      add_column :users, :notify_on_comments, :boolean
      add_column :users, :notify_watch_my_articles, :boolean

      Bare29User.reset_column_information
      Bare29User.find(:all).each do |u|
        # Definitions: 
        #  notify_via_email: use email to deliver notifications
        #  notify_on_new_articles: send a notification message (email, etc) when new articles added.
        #  notify_on_comments: send a notification message when new comments are added to watched articles.
        #  notify_watch_my_articles: tell the notifiation system to watch my articles.
        u.notify_via_email = true
        u.notify_on_new_articles = false
        u.notify_on_comments = true
        u.notify_watch_my_articles = true
        u.save!
      end
    end
  end

  def self.down
    Bare29User.transaction do
      remove_column :users, :notify_via_email
      remove_column :users, :notify_on_new_articles
      remove_column :users, :notify_on_comments
      remove_column :users, :notify_watch_my_articles
    end
  end
end
