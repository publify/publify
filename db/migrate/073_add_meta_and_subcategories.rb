class AddMetaAndSubcategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :keywords, :text
    add_column :categories, :description, :text
    add_column :categories, :parent_id, :integer
  end

  def self.down
    remove_column :categories, :keywords
    remove_column :categories, :description
    remove_column :categories, :parent_id
  end
end
