require 'xmlrpc/server'

class BackendController < ApplicationController
  cache_sweeper :blog_sweeper
  
  def xmlrpc    
    @server = XMLRPC::BasicServer.new
    @server.add_handler("blogger", BloggerApi.new(@request))
    @server.add_handler("metaWeblog", MetaWeblogApi.new(@request))
          
    headers['Content-Type'] = 'text/xml'
    render_text(@server.process(@request.raw_post))    
  end
  
end
