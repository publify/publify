class RelateContentsAndPageCaches < ActiveRecord::Migration
  def self.up
    create_table :contents_page_caches, :id => false do |t|
      t.column :content_id, :integer
      t.column :page_cache_id, :integer
    end
  end

  def self.down
    drop_table :contents_page_caches
  end
end
