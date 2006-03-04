class Bare21Comment < ActiveRecord::Base
  include BareMigration
end

class Bare21Content < ActiveRecord::Base
  include BareMigration
  set_inheritance_column :bogustype     # see migration #20 for why
end

class SuperclassComments < ActiveRecord::Migration
  def self.up
    STDERR.puts "Merging Comments into Contents table"

    Bare21Content.transaction do
      add_column :contents, :article_id, :integer
      add_column :contents, :email, :string
      add_column :contents, :url, :string
      add_column :contents, :ip, :string

      add_index :contents, :article_id

      if not $schema_generator
        Bare21Comment.reset_column_information
        Bare21Comment.find(:all).each do |c|
          Bare21Content.create(
            :type => 'Comment',
            :article_id => c.article_id,
            :title => c.title,
            :author => c.author,
            :email => c.email,
            :url => c.url,
            :ip => c.ip,
            :body => c.body,
            :body_html => c.body_html,
            :created_at => c.created_at,
            :updated_at => c.updated_at,
            :user_id => c.user_id,
            :guid => c.guid,
            :whiteboard => c.whiteboard)
        end
      end  

      remove_index :comments, :article_id
      drop_table :comments
    end
  end

  def self.down
    STDERR.puts "Recreating Comments from Contents table"

    Bare21Comment.transaction do
      create_table :comments do |t|
        t.column :article_id, :integer
        t.column :title, :string
        t.column :author, :string
        t.column :email, :string
        t.column :url, :string
        t.column :ip, :string
        t.column :body, :text
        t.column :body_html, :text
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
        t.column :user_id, :integer
        t.column :guid, :string
        t.column :whiteboard, :text
      end
  
      add_index :comments, :article_id

      Bare21Content.find(:all, :conditions => "type = 'Comment'").each do |c|
        Bare21Comment.create(
            :article_id => c.article_id,
            :title => c.title,
            :author => c.author,
            :email => c.email,
            :url => c.url,
            :ip => c.ip,
            :body => c.body,
            :body_html => c.body_html,
            :created_at => c.created_at,
            :updated_at => c.updated_at,
            :user_id => c.user_id,
            :guid => c.guid,
            :whiteboard => c.whiteboard)
      end
      Bare21Content.delete_all "type = 'Comment'"

      remove_index :contents, :article_id
      remove_column :contents, :article_id
      remove_column :contents, :email
      remove_column :contents, :url
      remove_column :contents, :ip
    end
  end
end
