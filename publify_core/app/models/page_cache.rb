# FIXME: This class is not a model anymore. Move elsewhere?
class PageCache
  def self.logger
    ::Rails.logger
  end

  def logger
    ::Rails.logger
  end

  # Delete all file save in path_cache by page_cache system
  def self.sweep_all
    zap_pages(%w(*))
  end

  def self.sweep_theme_cache
    zap_pages(%w(images/theme/* stylesheets/theme/* javascripts/theme/*))
  end

  def self.zap_pages(paths)
    true
  end
end
