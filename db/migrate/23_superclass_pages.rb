class Bare23Content < ActiveRecord::Base
  include BareMigration
  set_inheritance_column :bogustype     # see migration #20 for why
end

class Bare23Page < ActiveRecord::Base
  include BareMigration
end

class SuperclassPages < ActiveRecord::Migration
  def self.up
    STDERR.puts "Merging Pages into Content table"

    Bare23Content.transaction do
      add_column :contents, :name, :string

      if not $schema_generator
        Bare23Page.reset_column_information
        Bare23Page.find(:all).each do |p|
          Bare23Content.create(
            :type => 'Page',
            :title => p.name,
            :user_id => p.user_id,
            :body => p.body,
            :body_html => p.body_html,
            :created_at => p.created_at,
            :updated_at => p.modified_at,
            :title => p.title,
            :text_filter_id => p.text_filter_id)
        end
      end
      
      drop_table :pages
    end
  end

  def self.down
    STDERR.puts "Recreating pages table"

    Bare23Content.transaction do
      create_table :pages do |t|
        t.column :name, :string
        t.column :user_id, :integer
        t.column :body, :text
        t.column :body_html, :text
        t.column :created_at, :datetime
        t.column :modified_at, :datetime
        t.column :title, :string
        t.column :text_filter_id, :integer
        t.column :whiteboard, :text
      end
  
      Bare23Content.find(:all, :conditions => "type = 'Page'").each do |p|
        Bare23Page.create(
            :name => p.title,
            :user_id => p.user_id,
            :body => p.body,
            :body_html => p.body_html,
            :created_at => p.created_at,
            :modified_at => p.updated_at,
            :title => p.title,
            :text_filter_id => p.text_filter_id,
            :whiteboard => p.whiteboard)
      end
      Bare23Content.delete_all "type = 'Page'"
    end

    remove_column :contents, :name
  end
end
