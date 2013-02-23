require 'spec_helper'

describe Admin::CacheController do
  render_views

  before do
    FactoryGirl.create(:blog)
    #TODO Delete after removing fixtures
    Profile.delete_all
    @henri = FactoryGirl.create(:user, :login => 'henri', :profile => FactoryGirl.create(:profile_admin, :label => Profile::ADMIN))
    request.session = { :user => @henri.id }
  end

  describe "test_index" do
    before(:each) do
      get :index
    end
    
    it 'should render template index' do
      assert_template 'index'
    end    
  end
end
