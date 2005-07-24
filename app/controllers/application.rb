require_dependency 'login_system'

# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base
  include LoginSystem
  model :user
  
  before_filter :reload_settings
      
  def self.cache_page(content,path)
    super(content,path)
    PageCache.create(:name => path) rescue nil
  end

  def self.expire_page(path)
    super(path)
    if cache = PageCache.find(:first, :conditions => ['name = ?', path])
      cache.destroy
    end
  end

  def cache
    $cache ||= SimpleCache.new 1.hour
  end
  
  def reload_settings
    config.reload
  end
  
end
