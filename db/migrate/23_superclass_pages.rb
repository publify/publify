class SuperclassPages < ActiveRecord::Migration
  def self.up
    STDERR.puts "Extending content table"

    Content.transaction do
      add_column :contents, :name, :string

      STDERR.puts "Converting pages"

      if not $schema_generator
        ActiveRecord::Base.connection.select_all(%{
          SELECT
            name, user_id, body, body_html, created_at,
            updated_at, title, text_filter_id
          FROM pages
        }).each { |p| Page.create(p) }
      end
      
      drop_table :pages
    end
  end

  def self.down
    STDERR.puts "Recreating pages table"

    create_table :pages do |t|
      t.column :name, :string
      t.column :user_id, :integer
      t.column :body, :text
      t.column :body_html, :text
      t.column :created_at, :datetime
      t.column :modified_at, :datetime
      t.column :title, :string
      t.column :text_filter_id, :integer
    end

    ActiveRecord::Base.connection.select_all(%{
      SELECT
        name, user_id, body, body_html, created_at,
        updated_at, title, text_filter_id
      FROM contents
    }).each { |p| Page.create(p) }

    execute "DELETE FROM contents WHERE type = 'Page'"

    remove_column :contents, :name
  end
end

    
