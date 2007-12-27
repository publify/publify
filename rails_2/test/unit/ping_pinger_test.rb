require File.dirname(__FILE__) + '/../test_helper'

class PingPingerTest < Test::Unit::TestCase
  include FlexMock::TestCase
  
  def setup
    # avoid mocking constructor until we need it for something
    @pinger = Ping::Pinger.allocate
    class <<@pinger
      attr_writer :response
    end
  end

  def test_pingback_url_nil
    @pinger.response = flexmock(:body => '', :[] => nil)
    assert_nil @pinger.pingback_url
  end

  # TODO: why do we assume that we can XML attribute order?
  def test_pingback_url_from_body
    @pinger.response = flexmock(:body => '<link rel="pingback" href="foo" />', :[] => nil)
    assert_equal 'foo', @pinger.pingback_url
  end
  
  def test_pingback_url
    @pinger.response = flexmock(:body => '', :[] => :x_pingback)
    assert_equal :x_pingback, @pinger.pingback_url
  end
  
end