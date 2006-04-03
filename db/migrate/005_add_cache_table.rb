require 'fileutils'

class AddCacheTable < ActiveRecord::Migration
  def self.up
    FileUtils.rm_rf("public/articles")
    FileUtils.rm_rf("public/xml")
    FileUtils.rm_rf("public/index.html")
    create_table :page_caches do |t|
      t.column :name, :string
    end
    add_index :page_caches, :name
  end

  def self.down
    # TODO: how can this script sweep the page cache?
    # Like PageCache.sweep('/') but without calling a model?
    remove_index :page_caches, :name
    drop_table :page_caches
  end
end
