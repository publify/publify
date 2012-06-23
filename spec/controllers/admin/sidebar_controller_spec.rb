require 'spec_helper'

describe Admin::SidebarController do
  before do
    FactoryGirl.create(:blog)
    #TODO Delete after removing fixtures
    Profile.delete_all
    henri = FactoryGirl.create(:user, :login => 'henri', :profile => FactoryGirl.create(:profile_admin, :label => Profile::ADMIN))
    request.session = { :user => henri.id }
  end

  describe "rendering" do
    render_views

    it "test_index" do
      get :index
      assert_template 'index'
      assert_tag :tag => "div",
        :attributes => { :id => "sidebar-config" }
    end
  end
end
