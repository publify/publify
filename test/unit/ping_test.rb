require File.dirname(__FILE__) + '/../test_helper'

require 'http_mock'

class PingTest < Test::Unit::TestCase
  fixtures :articles, :settings
  
  def setup
    config.reload
  end

  def test_send_ping
    ping = @article1.pings.build("url" => "http://localhost/post/5?param=1")
    ping.send_ping("example.com")
    
    ping = Net::HTTP.pings.last
    assert_equal "localhost",ping.host
    assert_equal 80, ping.port
    assert_equal "/post/5?param=1", ping.query
    assert_equal "title=Article%201!&excerpt=body&url=example.com&blog_name=test%20blog", ping.post_data
  end
end
