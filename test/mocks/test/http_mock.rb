module Net
  remove_const "HTTP"
  class Request < Struct.new(:host, :port, :query, :post_data)
    def post(query, post)
      self.query = query
      self.post_data = post    
    end    
  end
  
  class Net::HTTP
      
    
    def self.start(host, port) 
      request = Request.new
      request.host = host
      request.port = port    
      
      @pings ||= []
      @pings << request

      yield request
    
    end
    
    def self.pings
      @pings
    end
    
  end  
end

