# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base
  
  def cache
    $cache ||= SimpleCache.new 1.hour
  end
  
  
  def config
    $config ||= Configuration.new
  end
end