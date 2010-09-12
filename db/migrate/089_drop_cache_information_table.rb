# Dummy class to declare the model before droping
class CacheInformation < ActiveRecord::Base

end

class DropCacheInformationTable < ActiveRecord::Migration
  def self.up
    # On 99.9% existing blogs, cache will be installed in public/
    # That means we first need to wipe existing files or they will be served
    # And the cache will never be accessed
    list = CacheInformation.find(:all)

    list.each do |file|
      path = File.join(::Rails.root.to_s, 'public', file.path)
      if File.exist?(path)
        FileUtils.rm(path)
      end
    end

    drop_table :cache_informations
  end

  def self.down
    create_table :cache_informations do |t|
      t.string :path
      t.timestamps
    end
    # Add index on path because there are validates_uniqueness on it
    add_index :cache_informations, :path
  end
end
