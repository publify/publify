class Bare29User < ActiveRecord::Base
  include BareMigration
end

class AddUserNotification < ActiveRecord::Migration
  def self.up
    modify_tables_and_update([:add_column, Bare29User, :notify_via_email,         :boolean],
                             [:add_column, Bare29User, :notify_on_new_articles,   :boolean],
                             [:add_column, Bare29User, :notify_on_comments,       :boolean],
                             [:add_column, Bare29User, :notify_watch_my_articles, :boolean]) do |u|
      # Definitions:
      #  notify_via_email: use email to deliver notifications
      #  notify_on_new_articles: send a notification message (email, etc) when new articles added.
      #  notify_on_comments: send a notification message when new comments are added to watched articles.
      #  notify_watch_my_articles: tell the notifiation system to watch my articles.
      u.notify_via_email = true
      u.notify_on_new_articles = false
      u.notify_on_comments = true
      u.notify_watch_my_articles = true
    end
  end

  def self.down
    modify_tables_and_update([:remove_column, Bare29User, :notify_via_email,         :boolean],
                             [:remove_column, Bare29User, :notify_on_new_articles,   :boolean],
                             [:remove_column, Bare29User, :notify_on_comments,       :boolean],
                             [:remove_column, Bare29User, :notify_watch_my_articles, :boolean])
  end
end
