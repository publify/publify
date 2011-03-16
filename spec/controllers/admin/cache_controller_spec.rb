require 'spec_helper'

describe Admin::CacheController do
  render_views

  before do
    Factory(:blog)
    request.session = { :user => users(:tobi).id }
  end

  it "test_index" do
    get :index
    assert_template 'index'
  end
end