require 'spec_helper'

describe Admin::SidebarController do
  before do
    Factory(:blog)
    request.session = { :user => users(:tobi).id }
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
