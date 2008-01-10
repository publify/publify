require File.dirname(__FILE__) + '/../../test/test_helper'
require File.dirname(__FILE__) + '/../spec_helper'
require 'theme_controller'

# Re-raise errors caught by the controller.
class ThemeController; def rescue_action(e) raise e end; end

describe ThemeController do
  integrate_views

  def test_stylesheets
    get :stylesheets, :filename => "application.css"
    assert_response :success
    assert_equal "text/css; charset=utf-8", @response.headers['type']
    assert_equal "inline; filename=\"application.css\"", @response.headers['Content-Disposition']
  end

  def test_images
    get :images, :filename => "spacer.gif"
    assert_response :success
    assert_equal "image/gif", @response.headers['type']
    assert_equal "inline; filename=\"spacer.gif\"", @response.headers['Content-Disposition']
  end

  def test_malicious_path
    get :stylesheets, :filename => "../../../config/database.yml"
    assert_response 404
  end

  def test_view_theming
    get :static_view_test
    assert_response :success

    assert @response.body =~ /Static View Test from standard issue/
  end

  def disabled_test_javascript
    get :stylesheets, :filename => "typo.js"
    assert_response :success
    assert_equal "text/javascript", @response.headers['type']
    assert_equal "inline; filename=\"typo.js\"", @response.headers['Content-Disposition']
  end
end
