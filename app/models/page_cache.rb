class PageCache < ActiveRecord::Base
  def self.public_path
    ActionController::Base.page_cache_directory
  end

  def self.sweep_all
    unless Blog.default && Blog.default.cache_option == "caches_action_with_params"
      self.zap_pages('index.*', 'articles', 'pages')
    end
  end

  def self.sweep_theme_cache
    self.zap_pages('images/theme', 'stylesheets/theme', 'javascripts/theme')
  end

  def self.zap_pages(*paths)
    srcs = paths.inject([]) { |o,v|
      o + Dir.glob(public_path + "/#{v}")
    }
    return true if srcs.empty?
    trash = Dir::tmpdir + "/typodel.#{UUID.random_create}"
    FileUtils.makedirs(trash)
    FileUtils.mv(srcs, trash, :force => true)
    FileUtils.rm_rf(trash)
  end
end
