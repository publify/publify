class PageCache
  def self.logger
    RAILS_DEFAULT_LOGGER
  end

  def logger
    RAILS_DEFAULT_LOGGER
  end

  def self.public_path
    ActionController::Base.page_cache_directory
  end

  # Delete all file save in path_cache by page_cache system
  def self.sweep_all
    self.zap_pages(%w{*})
  end

  def self.sweep_theme_cache
    self.zap_pages(%w{images/theme/* stylesheets/theme/* javascripts/theme/*})
  end

  def self.zap_pages(paths)
    # Ensure no one is going to wipe his own blog public directory
    # It happened once on a release and was no fun at all
    return if public_path == "#{RAILS_ROOT}/public"
    srcs = paths.inject([]) { |o,v|
      o + Dir.glob(public_path + "/#{v}")
    }
    return true if srcs.empty?
    trash = RAILS_ROOT + "/tmp/typodel.#{UUID.random_create}"
    FileUtils.makedirs(trash)
    FileUtils.mv(srcs, trash, :force => true)
    FileUtils.rm_rf(trash)
  end
  

  # DEPRECATED
  #
  # It's now deprecated. It's use only in migration
  # (20090311160502_create_cache_informations.rb)
  # Doesn't use anyway. The cache is now manage by CacheInformation
  # Method to swepp_all cache is allways self.sweep_all
  #
  # DEPRECATED
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
