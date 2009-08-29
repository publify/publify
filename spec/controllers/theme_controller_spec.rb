require File.dirname(__FILE__) + '/../spec_helper'

describe ThemeController do
  integrate_views

  def test_stylesheets
    get :stylesheets, :filename => "style.css"
    assert_response :success
    assert_equal "text/css", @response.content_type
    assert_equal "utf-8", @response.charset
    assert_equal "inline; filename=\"style.css\"", @response.headers['Content-Disposition']
  end

  def test_images
    get :images, :filename => "bg_white.png"
    assert_response :success
    assert_equal "image/png", @response.content_type
    assert_equal "inline; filename=\"bg_white.png\"", @response.headers['Content-Disposition']
  end

  def test_malicious_path
    get :stylesheets, :filename => "../../../config/database.yml"
    assert_response 404
  end

  def test_view_theming
    get :static_view_test
    assert_response :success

    assert @response.body =~ /Static View Test from typographic/
  end

  def disabled_test_javascript
    get :stylesheets, :filename => "typo.js"
    assert_response :success
    assert_equal "text/javascript", @response.content_type
    assert_equal "inline; filename=\"typo.js\"", @response.headers['Content-Disposition']
  end
end
