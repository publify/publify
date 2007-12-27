module XMLRPC
  class XMLRPC::Client
    attr_reader :method_name, :args
    attr_accessor :uri
    $xmlrpc_pings = []

    def initialize
    end

    def self.new2(uri)
      $xmlrpc_pings ||= []
      client = new
      client.uri = uri
      client
    end

    def self.pings
      $xmlrpc_pings
    end

    def call(name, *args)
      @method_name = name
      @args = *args
      $xmlrpc_pings ||= []
      $xmlrpc_pings << self
    end
  end
end
