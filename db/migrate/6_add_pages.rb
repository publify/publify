class AddPages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.column :name, :string
      t.column :user_id, :integer
      t.column :body, :text
      t.column :body_html, :text
      t.column :text_filter, :string
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
    end
  end

  def self.down
    drop_table :pages
  end
end
