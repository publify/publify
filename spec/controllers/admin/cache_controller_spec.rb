require 'spec_helper'

describe Admin::CacheController do
  render_views

  before do
    Factory(:blog)
    #TODO Delete after removing fixtures
    Profile.delete_all
    @henri = Factory(:user, :login => 'henri', :profile => Factory(:profile_admin, :label => Profile::ADMIN))
    request.session = { :user => @henri.id }
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
