require 'spec_helper'

describe Admin::SidebarController do
  before do
    Factory(:blog)
    #TODO Delete after removing fixtures
    Profile.delete_all
    henri = Factory(:user, :login => 'henri', :profile => Factory(:profile_admin, :label => Profile::ADMIN))
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
