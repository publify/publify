require 'spec_helper'

describe Admin::CacheController do
  render_views

  before do
    Factory(:blog)
    request.session = { :user => users(:tobi).id }
  end

  describe "test_index" do
    before(:each) do
      get :index
    end
    
    it 'should render template index' do
      assert_template 'index'
    end
    
    it 'should have Settings tab selected' do
      test_tabs "Settings"
    end
    
    it 'should have General settings, Write, Feedback, Cache, Users and Redirects with Cache selected' do
      subtabs = ["General settings", "Write", "Feedback", "Cache", "Users", "Redirects"]
      test_subtabs(subtabs, "Cache")
    end        
    
  end
end