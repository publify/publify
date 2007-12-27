class AddArticleGuid < ActiveRecord::Migration
  def self.up
    # the guid itself will be added later in the migration
    add_column :articles, :guid, :string
  end

  def self.down
    remove_column :articles, :guid
  end
end
