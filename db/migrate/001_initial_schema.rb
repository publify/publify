class Bare1Category < ActiveRecord::Base
  include BareMigration
end

class Bare1Article < ActiveRecord::Base
  include BareMigration
end

class Bare1ArticlesCategory < ActiveRecord::Base
  include BareMigration
end

class InitialSchema < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      create_table :users do |t|
        t.column :login, :string
        t.column :password, :string
      end

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
        t.column :text_filter, :string
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
        t.column :extended_html, :text
        t.column :permalink, :string
      end

      add_index :articles, :permalink

      create_table :categories do |t|
        t.column :name, :string
        t.column :position, :integer
      end

      category = Bare1Category.create(:name => 'General',
        :position => 1
      )

      article = Bare1Article.create(:title=>'Hello World!',
        :author=>'Mr Typo',
        :body=>'Welcome to Typo. This is your first article. Edit or delete it, then start blogging!',
        :allow_comments => 1,
        :allow_pings =>1,
        :published => 1,
        :permalink => 'hello-world'
      )

      create_table :blacklist_patterns do |t|
        t.column :type, :string
        t.column :pattern, :string
      end

      add_index :blacklist_patterns, :pattern

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
      end

      add_index :comments, :article_id

      create_table :pings do |t|
        t.column :article_id, :integer
        t.column :url, :string
        t.column :created_at, :datetime
      end

      add_index :pings, :article_id

      create_table :resources do |t|
        t.column :size, :integer
        t.column :filename, :string
        t.column :mime, :string
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
      end

      create_table :sessions do |t|
        t.column :sessid, :string
        t.column :data, :text
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
      end

      create_table :settings do |t|
        t.column :name, :string
        t.column :value, :string
        t.column :position, :integer
      end

      create_table :trackbacks do |t|
        t.column :article_id, :integer
        t.column :blog_name, :string
        t.column :title, :string
        t.column :excerpt, :string
        t.column :url, :string
        t.column :ip, :string
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
      end

      add_index :trackbacks, :article_id
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      remove_index :articles, :permalink
      remove_index :blacklist_patterns, :pattern
      remove_index :comments, :article_id
      remove_index :pings, :article_id
      remove_index :trackbacks, :article_id

      drop_table :users
      drop_table :articles
      drop_table :categories
      drop_table :blacklist_patterns
      drop_table :comments
      drop_table :pings
      drop_table :resources
      drop_table :sessions
      drop_table :settings
      drop_table :trackbacks
    end
  end
end
