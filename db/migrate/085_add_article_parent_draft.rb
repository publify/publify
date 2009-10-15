class AddArticleParentDraft < ActiveRecord::Migration
  def self.up
    add_column :contents, :parent_id, :integer
  end

  def self.down
    remove_column :contents, :parent_id
  end
end
