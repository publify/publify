require 'xmlrpc/server'


class BackendController < ApplicationController
  

  def xmlrpc    
    @server = XMLRPC::BasicServer.new
    @server.add_handler("blogger", BloggerApi.new)
    @server.add_handler("metaWeblog", MetaWeblogApi.new)
          
    headers['Content-Type'] = 'text/xml'
    data = @request.cgi.raw_post
    STDERR << data
    render_text(@server.process(data))
            
  end
  
end
