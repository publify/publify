module Net
  remove_const "HTTP"
  class Request < Struct.new(:host, :port, :query, :post_data, :headers)
    def post(query, post, headers = {})
      self.query = query
      self.post_data = post
      self.headers = headers
    end
  end

  class Net::HTTP
    def initialize(*args)
    end

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

    def self.next_response=(mock_response)
      @@response = mock_response
    end

    def self.get_response(*args)
      @@response
    end
  end
end
