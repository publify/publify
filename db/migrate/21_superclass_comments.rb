class SuperclassComments < ActiveRecord::Migration
  def self.up
    STDERR.puts "Extending Content table"

    Content.transaction do
      add_column :contents, :article_id, :integer
      add_column :contents, :email, :string
      add_column :contents, :url, :string
      add_column :contents, :ip, :string

      add_index :contents, :article_id

      STDERR.puts "Converting comments"

      ActiveRecord::Base.connection.select_all(%{
        SELECT
          article_id, title, author, email, url, ip, body, created_at,
          updated_at, user_id, guid, whiteboard
          FROM comments
      }).each do |c|
        Article.find(c["article_id"]).comments.create(c)
      end
    end

    drop_table :comments
  end

  def self.down
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

    ActiveRecord::Base.connection.select_all(%{
      SELECT
        article_id, title, author, email, url, ip, body, created_at,
        updated_at, user_id, guid, whiteboard
      FROM contents
    }).each do |c|
      Article.find(c["article_id"].comments.create(c))
    end

    execute "DELETE FROM contents WHERE type = 'Comment'"
    
    STDERR.puts "Reducing Content table"

    remove_index :contents, :article_id
    remove_column :contents, :article_id
    remove_column :contents, :email
    remove_column :contents, :url
    remove_column :contents, :ip
  end
end
