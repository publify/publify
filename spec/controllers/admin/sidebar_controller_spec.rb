require 'spec_helper'

describe Admin::SidebarController do
  render_views

  before do
    request.session = { :user => users(:tobi).id }
  end
  
  it "test_index" do
    get :index
    assert_template 'index'
    assert_tag :tag => "div",
      :attributes => { :id => "sidebar-config" }
  end

end