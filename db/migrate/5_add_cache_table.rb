require 'fileutils'

class AddCacheTable < ActiveRecord::Migration
  def self.up
    create_table :page_caches do |t|
      t.column :name, :string
    end
    add_index :page_caches,:name
    FileUtils.rm_rf("public/articles")
    FileUtils.rm_rf("public/xml")
    FileUtils.rm_rf("public/index.html")
  end

  def self.down
    PageCache.sweep('/')
    drop_table :page_caches
    remove_index :page_caches,:name
  end
end
