require File.dirname(__FILE__) + '/../../test/test_helper'
require File.dirname(__FILE__) + '/../spec_helper'
require 'theme_controller'

# Re-raise errors caught by the controller.
class ThemeController; def rescue_action(e) raise e end; end

describe ThemeController do
  integrate_views

  def test_stylesheets
    get :stylesheets, :filename => "style.css"
    assert_response :success
    assert_equal "text/css; charset=utf-8", @response.headers['type']
    assert_equal "inline; filename=\"style.css\"", @response.headers['Content-Disposition']
  end

  def test_images
    get :images, :filename => "bg_white.png"
    assert_response :success
    assert_equal "image/png", @response.headers['type']
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
    assert_equal "text/javascript", @response.headers['type']
    assert_equal "inline; filename=\"typo.js\"", @response.headers['Content-Disposition']
  end
end
