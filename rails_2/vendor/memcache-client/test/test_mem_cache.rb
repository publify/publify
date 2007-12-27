require 'stringio'
require 'test/unit'

$TESTING = true

require 'memcache'

class MemCache

  attr_reader :servers
  attr_writer :namespace

end

class FakeSocket

  attr_reader :written, :data

  def initialize
    @written = StringIO.new
    @data = StringIO.new
  end

  def write(data)
    @written.write data
  end

  def gets
    @data.gets
  end

  def read(arg)
    @data.read arg
  end

end

class FakeServer

  attr_reader :socket

  def initialize(socket = nil)
    @socket = socket || FakeSocket.new
  end

  def close
  end

end

class TestMemCache < Test::Unit::TestCase

  def setup
    @cache = MemCache.new 'localhost:1', :namespace => 'my_namespace'
  end

  def test_cache_get
    server = util_setup_fake_server

    assert_equal "\004\b\"\0170123456789",
                 @cache.cache_get(server, 'my_namespace:key')

    assert_equal "get my_namespace:key\r\n",
                 server.socket.written.string
  end

  def test_cache_get_miss
    socket = FakeSocket.new
    socket.data.write "END\r\n"
    socket.data.rewind
    server = FakeServer.new socket

    assert_equal nil, @cache.cache_get(server, 'my_namespace:key')

    assert_equal "get my_namespace:key\r\n",
                 socket.written.string
  end

  def test_crc32_ITU_T
    assert_equal 0, ''.crc32_ITU_T
    assert_equal 1260851911, 'my_namespace:key'.crc32_ITU_T
  end

  def test_initialize
    cache = MemCache.new :namespace => 'my_namespace', :readonly => true

    assert_equal 'my_namespace', cache.namespace
    assert_equal true, cache.readonly?
    assert_equal true, cache.servers.empty?
  end

  def test_initialize_compatible
    cache = MemCache.new ['localhost:11211', 'localhost:11212'],
            :namespace => 'my_namespace', :readonly => true

    assert_equal 'my_namespace', cache.namespace
    assert_equal true, cache.readonly?
    assert_equal false, cache.servers.empty?
  end

  def test_initialize_compatible_no_hash
    cache = MemCache.new ['localhost:11211', 'localhost:11212']

    assert_equal nil, cache.namespace
    assert_equal false, cache.readonly?
    assert_equal false, cache.servers.empty?
  end

  def test_initialize_compatible_one_server
    cache = MemCache.new 'localhost:11211'

    assert_equal nil, cache.namespace
    assert_equal false, cache.readonly?
    assert_equal false, cache.servers.empty?
  end

  def test_initialize_compatible_bad_arg
    e = assert_raise ArgumentError do
      cache = MemCache.new Object.new
    end

    assert_equal 'first argument must be Array, Hash or String', e.message
  end

  def test_initialize_too_many_args
    assert_raises ArgumentError do
      MemCache.new 1, 2, 3
    end
  end

  def test_get
    util_setup_fake_server

    value = @cache.get 'key'

    assert_equal "get my_namespace:key\r\n",
                 @cache.servers.first.socket.written.string

    assert_equal '0123456789', value
  end

  def test_get_cache_get_IOError
    socket = Object.new
    def socket.write(arg) raise IOError, 'some io error'; end
    server = FakeServer.new socket

    @cache.servers = []
    @cache.servers << server

    e = assert_raise MemCache::MemCacheError do
      @cache.get 'my_namespace:key'
    end

    assert_equal 'some io error', e.message
  end

  def test_get_cache_get_SystemCallError
    socket = Object.new
    def socket.write(arg) raise SystemCallError, 'some syscall error'; end
    server = FakeServer.new socket

    @cache.servers = []
    @cache.servers << server

    e = assert_raise MemCache::MemCacheError do
      @cache.get 'my_namespace:key'
    end

    assert_equal 'unknown error - some syscall error', e.message
  end

  def test_get_no_connection
    @cache.servers = 'localhost:1'
    e = assert_raise MemCache::MemCacheError do
      @cache.get 'key'
    end

    assert_equal 'No connection to server', e.message
  end

  def test_get_no_servers
    @cache.servers = []
    e = assert_raise MemCache::MemCacheError do
      @cache.get 'key'
    end

    assert_equal 'No active servers', e.message
  end

  def test_get_multi
    util_setup_fake_server

    values = @cache.get_multi 'keya', 'keyb'

    assert_equal "get my_namespace:keya\r\nget my_namespace:keyb\r\n",
                 @cache.servers.first.socket.written.string

    expected = { 'keya' => '0123456789', 'keyb' => nil }
    assert_equal expected, values
  end

  def test_get_server_for_key
    server = @cache.get_server_for_key 'key'
    assert_equal 'localhost', server.host
    assert_equal 1, server.port
  end

  def test_get_server_for_key_multiple
    s1 = util_setup_server @cache, 'one.example.com', ''
    s2 = util_setup_server @cache, 'two.example.com', ''
    @cache.instance_variable_set :@servers, [s1, s2]
    @cache.instance_variable_set :@buckets, [s1, s2]

    server = @cache.get_server_for_key 'keya'
    assert_equal 'two.example.com', server.host
    server = @cache.get_server_for_key 'keyb'
    assert_equal 'one.example.com', server.host
  end

  def test_get_server_for_key_no_servers
    @cache.servers = []

    e = assert_raise MemCache::MemCacheError do
      @cache.get_server_for_key 'key'
    end

    assert_equal 'No servers available', e.message
  end

  def test_make_cache_key
    assert_equal 'my_namespace:key', @cache.make_cache_key('key')
    @cache.namespace = nil
    assert_equal 'key', @cache.make_cache_key('key')
  end

  def test_basic_threaded_operations_should_work
    cache = MemCache.new :multithread => true,
                         :namespace => 'my_namespace',
                         :readonly => false
    server = util_setup_server cache, 'example.com', "OK\r\n"
    cache.instance_variable_set :@servers, [server]

    assert_nothing_raised do
      cache.set "test", "test value"
    end
  end

  def test_basic_unthreaded_operations_should_work
    cache = MemCache.new :multithread => false,
                         :namespace => 'my_namespace',
                         :readonly => false
    server = util_setup_server cache, 'example.com', "OK\r\n"
    cache.instance_variable_set :@servers, [server]

    assert_nothing_raised do
      cache.set "test", "test value"
    end
  end
 
  def util_setup_fake_server
    server = FakeServer.new
    server.socket.data.write "VALUE my_namepsace:key 0 14\r\n"
    server.socket.data.write "\004\b\"\0170123456789\r\n"
    server.socket.data.write "END\r\n"
    server.socket.data.rewind

    @cache.servers = []
    @cache.servers << server

    return server
  end

  def util_setup_server(memcache, host, responses)
    server = MemCache::Server.new memcache, host
    server.instance_variable_set :@sock, StringIO.new(responses)

    @cache.servers = []
    @cache.servers << server

    return server
  end

end

