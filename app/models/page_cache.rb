class PageCache < ActiveRecord::Base
  def self.public_path
    ActionController::Base.page_cache_directory
  end

  def self.sweep_all
    logger.debug "PageCache - sweep_all called"
    unless Blog.default && Blog.default.cache_option == "caches_action_with_params"
      self.zap_pages('index.*', 'articles.*', 'articles', 'pages',
                     'pages.*', 'feedback', 'feedback.*',
                     'comments', 'comments.*',
                     'categories', 'categories.*',
                     'tags', 'tags.*')
    end
  end

  def self.sweep_theme_cache
    logger.debug "PageCache - sweep_theme_cache called"
    self.zap_pages('images/theme', 'stylesheets/theme', 'javascripts/theme')
  end

  def self.zap_pages(*paths)
    logger.debug "PageCache - About to zap: #{paths.inspect}"
    srcs = paths.inject([]) { |o,v|
      o + Dir.glob(public_path + "/#{v}")
    }
    return true if srcs.empty?
    logger.debug "PageCache - About to delete: #{srcs.inspect}"
    trash = RAILS_ROOT + "/tmp/typodel.#{UUID.random_create}"
    FileUtils.makedirs(trash)
    FileUtils.mv(srcs, trash, :force => true)
    FileUtils.rm_rf(trash)
  end
end
