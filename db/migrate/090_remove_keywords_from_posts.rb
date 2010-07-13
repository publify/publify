class RemoveKeywordsFromPosts < ActiveRecord::Migration
  def self.up
    remove_column :contents, :keywords
  end

  def self.down
    add_column :contents, :keywords, :string
  end
end
