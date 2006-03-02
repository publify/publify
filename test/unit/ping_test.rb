require File.dirname(__FILE__) + '/../test_helper'

require 'http_mock'
require 'xmlrpc_mock'

class PingTest < Test::Unit::TestCase
  fixtures :contents, :settings
  
  def setup
    config.reload
  end

  def test_send_pingback

    # We've linked to http://anotherblog.org/a-post from
    # http://myblog.net/referring-post and discovered a pingback
    # listener at http://anotherblog.org/xml-rpc

    ping = contents(:article1).pings.build("url" =>
                                           "http://anotherblog.org/a-post")
    ping.send_pingback("http://myblog.net/referring-post",
                       "http://anotherblog.org/xml-rpc")

    ping = XMLRPC::Client.pings.last
    assert_equal "http://anotherblog.org/xml-rpc", ping.uri
    assert_equal "pingback.ping", ping.method_name
    assert_equal "http://myblog.net/referring-post", ping.args[0]
    assert_equal "http://anotherblog.org/a-post", ping.args[1]
  end

  def test_send_trackback

    # We've linked to http://anotherblog.org/a-post from
    # http://myblog.net/referring-post and discovered the trackback
    # URL http://anotherblog.org/a-post/trackback

    ping = contents(:article1).pings.build("url" =>
                                           "http://anotherblog.org/a-post")
    ping.send_trackback("http://myblog.net/referring-post",
                        "http://anotherblog.org/a-post/trackback")

    ping = Net::HTTP.pings.last
    assert_equal "anotherblog.org", ping.host
    assert_equal 80, ping.port
    assert_equal "/a-post/trackback", ping.query
    assert_equal "title=Article%201!&excerpt=body&url=http://myblog.net/referring-post&blog_name=test%20blog", ping.post_data
  end

  def test_send_weblogupdatesping

    # Our blog, named config[:blog_name] at http://myblog.net/ has
    # changed through us posting http://myblog.net/new-post. This,
    # we'd like to tell to http://rpc.technorati.com/rpc/ping.

    ping = contents(:article1).pings.build("url" =>
                                           "http://rpc.technorati.com/rpc/ping")
    ping.send_weblogupdatesping("http://myblog.net/",
                                "http://myblog.net/new-post")

    ping = XMLRPC::Client.pings.last
    assert_equal "http://rpc.technorati.com/rpc/ping", ping.uri
    assert_equal "weblogUpdates.ping", ping.method_name
    assert_equal config[:blog_name], ping.args[0]
    assert_equal "http://myblog.net/", ping.args[1]
    assert_equal "http://myblog.net/new-post", ping.args[2]
  end
end
