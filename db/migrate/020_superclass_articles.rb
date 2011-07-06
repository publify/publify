class Bare20Article < ActiveRecord::Base
  include BareMigration

  # need to point the primary key somewhere else so we can manually
  # set this field for each article.
  #set_primary_key :boguskey
end

class Bare20Content < ActiveRecord::Base
  include BareMigration

# From active_record/base.rb: "the primary key and inheritance column can
# never be set by mass-assignment for security reasons."  Because this
# script wants to set 'id' and 'type', we need to fool activerecord by
# setting them to bogus values.
  set_inheritance_column :bogustype
  #set_primary_key :boguskey
end

class SuperclassArticles < ActiveRecord::Migration
  def self.config
    ActiveRecord::Base.configurations
  end

  def self.up
    say "Merging Articles into Contents table"

    # Make sure our index is in a known state
    # Comment because in migration 001, there are already a creation of this index
    #add_index :articles, :permalink rescue nil

    Bare20Article.transaction do
      create_table :contents do |t|
#       ActiveRecord::Base.connection.send(:create_table, [:contents]) do |t|
        t.column :type, :string
        t.column :title, :string
        t.column :author, :string
        t.column :body, :text
        t.column :body_html, :text
        t.column :extended, :text
        t.column :excerpt, :text
        t.column :keywords, :string
        t.column :allow_comments, :integer
        t.column :allow_pings, :integer
        t.column :published, :integer, :default => 1
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
        t.column :extended_html, :text
        t.column :user_id, :integer
        t.column :permalink, :string
        t.column :guid, :string
        t.column :text_filter_id, :integer
        t.column :whiteboard, :text
      end

      if config[::Rails.env]['adapter'] == 'postgresql'
        execute "select nextval('contents_id_seq')"
      end

      if not $schema_generator

        Bare20Article.find(:all).each do |a|
          t = Bare20Content.new(
            :type => 'Article',
            :title => a.title,
            :author => a.author,
            :body => a.body,
            :body_html => a.body_html,
            :extended => a.extended,
            :excerpt => a.excerpt,
            :keywords => a.keywords,
            :allow_comments => a.allow_comments,
            :allow_pings => a.allow_pings,
            :published => a.published,
            :created_at => a.created_at,
            :updated_at => a.updated_at,
            :extended_html => a.extended_html,
            :user_id => a.user_id,
            :permalink => a.permalink,
            :guid => a.guid,
            :text_filter_id => a.text_filter_id,
            :whiteboard => a.whiteboard)
          # can't use id accessor because it uses the bogus primary key
          t.send(:write_attribute, :id, a.send(:read_attribute, :id))
          t.save!
        end

        if config[::Rails.env]['adapter'] == 'postgresql'
          say "Resetting PostgreSQL sequences", true
          execute "select setval('contents_id_seq',max(id)) from contents"
          execute "select nextval('contents_id_seq')"
        end
      end

      remove_index :articles, :permalink
      drop_table :articles
    end
  end

  def self.down
    Bare20Content.transaction do
      say "Recreating Articles from Contents table."

      create_table :articles do |t|
        t.column :title, :string
        t.column :author, :string
        t.column :body, :text
        t.column :body_html, :text
        t.column :extended, :text
        t.column :excerpt, :text
        t.column :keywords, :string
        t.column :allow_comments, :integer
        t.column :allow_pings, :integer
        t.column :published, :integer, :default => 1
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
        t.column :extended_html, :text
        t.column :user_id, :integer
        t.column :permalink, :string
        t.column :guid, :string
        t.column :text_filter_id, :integer
        t.column :whiteboard, :text
      end

      if config[::Rails.env]['adapter'] == 'postgresql'
        execute "select nextval('articles_id_seq')"
      end

      add_index :articles, :permalink

      if not $schema_generator
        Bare20Content.find(:all, :conditions => "type = 'Article'").each do |a|
          t = Bare20Article.new(
             :title => a.title,
             :author => a.author,
             :body => a.body,
             :body_html => a.body_html,
             :extended => a.extended,
             :excerpt => a.excerpt,
             :keywords => a.keywords,
             :allow_comments => a.allow_comments,
             :allow_pings => a.allow_pings,
             :published => a.published,
             :created_at => a.created_at,
             :updated_at => a.updated_at,
             :extended_html => a.extended_html,
             :user_id => a.user_id,
             :permalink => a.permalink,
             :guid => a.guid,
             :text_filter_id => a.text_filter_id,
             :whiteboard => a.whiteboard)
           # can't use id accessor because it uses the bogus primary key
           t.send(:write_attribute, :id, a.send(:read_attribute, :id))
           t.save!
        end

        if config[::Rails.env]['adapter'] == 'postgres'
          say "Resetting PostgreSQL sequences", true
          execute "select setval('articles_id_seq',max(id)+1) from articles"
        end

      end

      # script 21 saved the comments, this script saved the articles.
      drop_table :contents
    end
  end
end
