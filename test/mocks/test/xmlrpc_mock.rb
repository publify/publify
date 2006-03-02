module XMLRPC
  class XMLRPC::Client
    attr_reader :method_name, :args
    attr_accessor :uri

    def initialize
    end

    def self.new2(uri)
      @@pings ||= []
      client = new
      client.uri = uri
      client
    end

    def self.pings
      @@pings
    end

    def call(name, *args)
      @method_name = name
      @args = *args
      @@pings ||= []
      @@pings << self
    end
  end
end
