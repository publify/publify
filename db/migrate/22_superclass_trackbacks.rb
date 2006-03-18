class Bare22Content < ActiveRecord::Base
  include BareMigration
  set_inheritance_column :bogustype     # see migration #20 for why
end

class Bare22Trackback < ActiveRecord::Base
  include BareMigration
end

class SuperclassTrackbacks < ActiveRecord::Migration
  def self.up
    STDERR.puts "Merging Trackbacks into Content table"
    # Ensure that the index we're going to remove in the transaction
    # is actually there (otherwise Postgres breaks)
    add_index(:trackbacks, :article_id) rescue nil

    Bare22Content.transaction do
      add_column :contents, :blog_name, :string

      if not $schema_generator
        Bare22Trackback.reset_column_information
        Bare22Trackback.find(:all).each do |tb|
          a = Bare22Content.find(tb.article_id)
          Bare22Content.create(
            :type => 'Trackback',
            :article_id => tb.article_id,
            :blog_name => tb.blog_name,
            :title => tb.title,
            :excerpt => tb.excerpt,
            :url => tb.url,
            :ip => tb.ip,
            :created_at => tb.created_at,
            :updated_at => tb.updated_at,
            :guid => tb.guid)
        end
      end

      remove_index :trackbacks, :article_id
      drop_table :trackbacks
    end
  end

  def self.down
    STDERR.puts "Recreating Trackbacks from Contents table"

    Bare22Content.transaction do
      create_table :trackbacks do |t|
        t.column :article_id, :integer
        t.column :blog_name, :string
        t.column :title, :string
        t.column :excerpt, :string
        t.column :url, :string
        t.column :ip, :string
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
        t.column :guid, :string
      end

      Bare22Content.find(:all, :conditions => "type = 'Trackback'").each do |tb|
        Bare22Trackback.create(
            :article_id => tb.article_id,
            :blog_name => tb.blog_name,
            :title => tb.title,
            :excerpt => tb.excerpt,
            :url => tb.url,
            :ip => tb.ip,
            :created_at => tb.created_at,
            :updated_at => tb.updated_at,
            :guid => tb.guid)
      end
      Bare22Content.delete_all "type = 'Trackback'"

      add_index :trackbacks, :article_id
      remove_column :contents, :blog_name
    end
  end
end
