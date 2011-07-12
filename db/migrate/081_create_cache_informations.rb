class CreateCacheInformations < ActiveRecord::Migration
  class PageCache < ActiveRecord::Base

    def self.public_path
      ActionController::Base.page_cache_directory
    end

    def self.zap_pages(paths)
      # Ensure no one is going to wipe his own blog public directory
      # It happened once on a release and was no fun at all
      return if public_path == "#{::Rails.root.to_s}/public"
      srcs = paths.map { |v|
        Dir.glob(public_path + "/#{v}")
      }.flatten
      return true if srcs.empty?
      trash = ::Rails.root.to_s + "/tmp/typodel.#{UUIDTools::UUID.random_create}"
      FileUtils.makedirs(trash)
      FileUtils.mv(srcs, trash, :force => true)
      FileUtils.rm_rf(trash)
    end

    def self.old_sweep_all
      logger.debug "PageCache - sweep_all called by #{caller[1].inspect}"
      unless Blog.default.nil?
        self.zap_pages(%w{index.* articles.* pages page
                       pages.* feedback feedback.*
                       comments comments.*
                       category categories.* xml
                       sitemap.xml
                       *.rss *.atom
                       tag tags.* category archives.*})

        self.zap_pages((1990..2020))
        self.zap_pages([*1990..2020].collect { |y| "#{y}.*" })
      end
    end

  end

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
