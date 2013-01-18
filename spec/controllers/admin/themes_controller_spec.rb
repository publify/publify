require 'spec_helper'

describe Admin::ThemesController do
  render_views

  before do
    FactoryGirl.create(:blog)
    #TODO Delete after removing fixtures
    Profile.delete_all
    henri = FactoryGirl.create(:user, :login => 'henri', :profile => FactoryGirl.create(:profile_admin, :label => Profile::ADMIN))
    request.session = { :user => henri.id }
  end

  describe 'test index' do
    before(:each) do
      get :index
    end

    it "assigns @themes for the :index action" do
      assert_response :success
      assert_not_nil assigns(:themes)
    end
  end

  it "redirects to :index after the :switchto action" do
    get :switchto, :theme => 'typographic'
    assert_response :redirect, :action => 'index'
  end

  it "returns succes for the :preview action" do
    get :preview, :theme => 'typographic'
    assert_response :success
  end  
end
