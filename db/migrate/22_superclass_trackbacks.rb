class SuperclassTrackbacks < ActiveRecord::Migration
  def self.up
    STDERR.puts "Extending Content table"

    Content.transaction do
      add_column :contents, :blog_name, :string

      STDERR.puts "Converting trackbacks"

      if not $schema_generator
        ActiveRecord::Base.connection.select_all(%{
          SELECT
            article_id, blog_name, title, excerpt, url, ip,
            created_at, updated_at, guid
          FROM trackbacks
        }).each do |tb|
          Article.find(tb["article_id"]).trackbacks.create(tb)
        end
      end
    end
    remove_index :trackbacks, :article_id rescue nil
    drop_table :trackbacks rescue nil
  end

  def self.down
    STDERR.puts "Recreating trackbacks table"
    
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

    add_index :trackbacks, :article_id

    STDERR.puts "Converting trackbacks"

    ActiveRecord::Base.connection.select_all(%{
      SELECT
        article_id, blog_name, title, excerpt, url, ip,
        created_at, updated_at, guid
      FROM contents
    }).each do |tb|
      Article.find(tb["article_id"].trackbacks.create(tb))
    end

    STDERR.puts "Reducing Content table"
    
    execute "DELETE FROM contents WHERE type = 'Trackback'"
    
    remove_column :contents, :blog_name
  end
end



