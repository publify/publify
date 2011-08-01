class AddsContentType < ActiveRecord::Migration
  def self.up
    add_column :contents, :post_type, :string, :default => 'read'
    
    create_table :post_types do |t|
      t.column :name,        :string
      t.column :permalink,   :string
      t.column :description, :string
    end
  end

  def self.down
    remove_column :contents, :post_type
    drop_table :post_types
  end
end
