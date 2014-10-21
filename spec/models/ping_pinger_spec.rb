require 'rails_helper'

describe 'Ping::Pinger with Test::Unit', type: :model do
  before do
    FactoryGirl.create(:blog)
    # avoid mocking constructor until we need it for something
    @pinger = Ping::Pinger.allocate
    class << @pinger
      attr_writer :response
    end
  end

  it 'test_pingback_url_nil' do
    @pinger.response = double('response')
    allow(@pinger.response).to receive(:body).and_return('')
    allow(@pinger.response).to receive(:[]).and_return(nil)
    assert_nil @pinger.pingback_url
  end

  # TODO: why do we assume that we can XML attribute order?
  it 'test_pingback_url_from_body' do
    @pinger.response = double('response')
    allow(@pinger.response).to receive(:body).and_return('<link rel="pingback" href="foo" />')
    allow(@pinger.response).to receive(:[]).and_return(nil)
    assert_equal 'foo', @pinger.pingback_url
  end

  it 'test_pingback_url' do
    @pinger.response = double('response')
    allow(@pinger.response).to receive(:body).and_return('')
    allow(@pinger.response).to receive(:[]).and_return(:x_pingback)
    assert_equal :x_pingback, @pinger.pingback_url
  end
end
