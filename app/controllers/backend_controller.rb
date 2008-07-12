class BackendController < ContentController
  skip_before_filter :verify_authenticity_token
  
  cache_sweeper :blog_sweeper
  session :off

  web_service_dispatching_mode :layered
  web_service_exception_reporting false

  web_service(:metaWeblog)  { MetaWeblogService.new(self) }
  web_service(:mt)          { MovableTypeService.new(self) }
  web_service(:blogger)     { BloggerService.new(self) }

  alias xmlrpc api
end
