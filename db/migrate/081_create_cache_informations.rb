class CreateCacheInformations < ActiveRecord::Migration
  def self.up

    # With this migration, Old cache is useless. So we need delete all old cache
    # Now what page is in cache is manage by cache_informations table
    PageCache.old_sweep_all

    # In commit before, cache manage by file. We delete this cache if exist.
    # It's use only to all edge blog updated several time
    if File.exist?(File.join(Rails.root,'path_cache'))
      File.read(File.join(Rails.root,'path_cache')).split("\n").each do |page_save|
        FileUtils.rm File.join(PageCache.public_path, page_save)
      end
      FileUtils.rm_f File.join(Rails.root,'path_cache')
    end

    create_table :cache_informations do |t|
      t.string :path
      t.timestamps
    end
    # Add index on path because there are validates_uniqueness on it
    add_index :cache_informations, :path
  end

  def self.down
    drop_table :cache_informations
  end
end
