require 'spec_helper'

describe ThemeController do
  render_views

  before(:each) { FactoryGirl.create(:blog) }

  it "test_stylesheets" do
    get :stylesheets, :filename => "style.css"
    assert_response :success
    assert_equal "text/css; charset=utf-8", @response.content_type
    assert_equal "utf-8", @response.charset
    assert_equal "inline; filename=\"style.css\"", @response.headers['Content-Disposition']
  end

  it "test_images" do
    get :images, :filename => "bg_white.png"
    assert_response :success
    assert_equal "image/png", @response.content_type
    assert_equal "inline; filename=\"bg_white.png\"", @response.headers['Content-Disposition']
  end

  it "test_malicious_path" do
    get :stylesheets, :filename => "../../../config/database.yml"
    assert_response 404
  end

  it "test_view_theming" do
    get :static_view_test
    assert_response :success

    assert @response.body =~ /Static View Test from typographic/
  end

  it "disabled_test_javascript"
  if false
    get :stylesheets, :filename => "typo.js"
    assert_response :success
    assert_equal "text/javascript", @response.content_type
    assert_equal "inline; filename=\"typo.js\"", @response.headers['Content-Disposition']
  end
end
