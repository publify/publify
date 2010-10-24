require 'spec_helper'

describe Admin::SidebarController do
  render_views

  it "test_index" do
    Factory(:blog)
    request.session = { :user => users(:tobi).id }
    get :index
    assert_template 'index'
    assert_tag :tag => "div",
      :attributes => { :id => "sidebar-config" }
  end

end
