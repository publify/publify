require 'fileutils'

class AddCacheTable < ActiveRecord::Migration
  def self.up
    create_table :caches do |t|
      t.column :page_name, :text
    end
    add_index :caches,:page_name
    FileUtils.rm_rf("public/articles")
    FileUtils.rm_rf("public/xml")
    FileUtils.rm_rf("public/index.html")
  end

  def self.down
    Cache.sweep('/')
    drop_table :caches
    remove_index :caches,:page_name
  end
end
