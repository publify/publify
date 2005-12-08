class SuperclassArticles < ActiveRecord::Migration
  def self.up
#    raise "Back up your database and then remove line 3 from db/migrate/20_superclass_articles.rb"
    
    STDERR.puts "Renaming Articles table"

    Comment.transaction do
      create_table :contents do |t|
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
        t.column :comments_count, :integer
        t.column :trackbacks_count, :integer
      end

      if not $schema_generator
        STDERR.puts "Copying article data"
        execute "insert into contents (
          id,title,author,body,body_html,extended,excerpt,keywords,allow_comments,allow_pings,published,
          created_at,updated_at,extended_html,user_id,permalink,guid,text_filter_id,whiteboard) (
            select id,title,author,body,body_html,extended,excerpt,keywords,allow_comments,allow_pings,published,
                   created_at,updated_at,extended_html,user_id,permalink,guid,text_filter_id,whiteboard
            from articles)"
        
        config = ActiveRecord::Base.configurations
        if config[RAILS_ENV]['adapter'] == 'postgresql'
          STDERR.puts "Resetting PostgreSQL sequences"
          execute "select setval('contents_id_seq',max(id)) from contents"
          execute "select nextval('contents_id_seq')"
        end
      end

      remove_index :articles, :permalink
      drop_table :articles

      STDERR.puts "Adding a type column"

      add_column :contents, :type, :string
      Content.update_all("type = 'Article'")
    end
  end

  def self.down
    Comment.transaction do
      STDERR.puts "Removing type column"
      remove_column :contents, :type

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

      if not $schema_generator
        STDERR.puts "Copying article data"
        execute "insert into articles (select * from contents)"

        config = ActiveRecord::Base.configurations
        if config[RAILS_ENV]['adapter'] == 'postgres'
          STDERR.puts "Resetting PostgreSQL sequences"
          execute "select setval('articles_id_seq',max(id)+1) from articles"
        end
      end

      drop_table :contents
    end
  end
end
  
    
