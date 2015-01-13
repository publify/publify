# FIXME: This class is not a model anymore. Move elsewhere?
class PageCache
  def self.logger
    ::Rails.logger
  end

  def logger
    ::Rails.logger
  end

  def self.public_path
    ActionController::Base.page_cache_directory
  end

  # Delete all file save in path_cache by page_cache system
  def self.sweep_all
    zap_pages(%w(*))
  end

  def self.sweep_theme_cache
    zap_pages(%w(images/theme/* stylesheets/theme/* javascripts/theme/*))
  end

  def self.zap_pages(paths)
    # Ensure no one is going to wipe his own blog public directory
    # It happened once on a release and was no fun at all
    return if public_path == "#{::Rails.root}/public"
    paths.each do|v|
      FileUtils.rm_rf(Dir.glob(public_path + "/#{v}"))
    end
    true
  end
end
