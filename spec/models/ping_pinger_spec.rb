require 'spec_helper'

describe 'Ping::Pinger with Test::Unit' do
  before do
    Factory(:blog)
    # avoid mocking constructor until we need it for something
    @pinger = Ping::Pinger.allocate
    class << @pinger
      attr_writer :response
    end
  end

  it "test_pingback_url_nil" do
    @pinger.response = mock('response')
    @pinger.response.stub!(:body).and_return('')
    @pinger.response.stub!(:[]).and_return(nil)
    assert_nil @pinger.pingback_url
  end

  # TODO: why do we assume that we can XML attribute order?
  it "test_pingback_url_from_body" do
    @pinger.response = mock('response')
    @pinger.response.stub!(:body).and_return('<link rel="pingback" href="foo" />')
    @pinger.response.stub!(:[]).and_return(nil)
    assert_equal 'foo', @pinger.pingback_url
  end

  it "test_pingback_url" do
    @pinger.response = mock('response')
    @pinger.response.stub!(:body).and_return('')
    @pinger.response.stub!(:[]).and_return(:x_pingback)
    assert_equal :x_pingback, @pinger.pingback_url
  end
end
