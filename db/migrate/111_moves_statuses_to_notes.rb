class MovesStatusesToNotes < ActiveRecord::Migration
  class Profile < ActiveRecord::Base
    include BareMigration

    serialize :profiles
  end

  class Content < ActiveRecord::Base
    include BareMigration
  end
  
  class Status < Content
    include BareMigration
  end
  
  def self.up
    say "Rename statuses as notes"

    Profile.find_by_label("admin").try :update_attributes,
      modules: [:dashboard, :articles, :notes, :pages, :feedback, :media, :themes, :sidebar, :profile, :users, :settings, :seo, ]
    Profile.find_by_label("publisher").try :update_attributes,
      modules: [:dashboard, :articles, :notes, :pages, :feedback, :media, :profile]
      
    statuses = Content.where("type = ?", "Status")
    statuses.each do |status|
      say "#{status.id} #{status.type}"
      status.type = "Note"
      status.save
    end
  end

  def self.down
    say "Rename notes as statuses"

    Profile.find_by_label("admin").try :update_attributes,
      modules: [:dashboard, :articles, :statuses, :pages, :media, :feedback, :themes, :sidebar, :users, :settings, :profile, :seo]
    Profile.find_by_label("publisher").try :update_attributes,
      modules: [:dashboard, :write, :statuses, :content, :feedback, :profile]
      
    statuses = Note.find(:all)
    statuses.each do |status|
      status.type = "Status"
      status.save
    end

  end
end
