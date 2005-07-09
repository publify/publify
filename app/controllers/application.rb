require_dependency 'login_system'

# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base
  include LoginSystem
  model :user
  
  before_filter :reload_settings
      
  def cache
    $cache ||= SimpleCache.new 1.hour
  end
  
  def reload_settings
    config.reload
  end
  
end