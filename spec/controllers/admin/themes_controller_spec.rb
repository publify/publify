require 'spec_helper'

describe Admin::ThemesController do
  render_views

  before do
    Factory(:blog)
    request.session = { :user => users(:tobi).id }
  end

  it "assigns @themes for the :index action" do
    get :index
    assert_response :success
    assert_not_nil assigns(:themes)
  end

  it "redirects to :index after the :switchto action" do
    get :switchto, :theme => 'typographic'
    assert_response :redirect, :action => 'index'
  end

  it "returns succes for the :preview action" do
    get :preview, :theme => 'typographic'
    assert_response :success
  end

  it "shows a list of css and erb files for the :editor action" do
    get :editor
    assert_response :success
    response.should have_selector("a", :content => "colors.css")
    response.should have_selector("a", :content => "default.html.erb")
  end
end
