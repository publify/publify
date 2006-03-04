class AddTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.column :name, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end

    create_table :articles_tags, :id => false do |t|
      t.column :article_id, :integer
      t.column :tag_id, :integer
    end
  end

  def self.down
    drop_table :tags
    drop_table :articles_tags
  end
end
