require File.dirname(__FILE__) + '/../test_helper'
require 'theme_controller'

# Re-raise errors caught by the controller.
class ThemeController; def rescue_action(e) raise e end; end

class ThemeControllerTest < Test::Unit::TestCase
  def setup
    @controller = ThemeController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
  end
  
  def test_stylesheets
    get :stylesheets, :filename => "azure.css"
    assert_response :success
    assert_equal "text/css", @response.headers['Content-Type']
    assert_equal "inline; filename=\"azure.css\"", @response.headers['Content-Disposition']
  end

  def test_images
    get :images, :filename => "bg-tile.gif"
    assert_response :success
    assert_equal "image/gif", @response.headers['Content-Type']
    assert_equal "inline; filename=\"bg-tile.gif\"", @response.headers['Content-Disposition']
  end

  def test_malicious_path
    get :stylesheets, :filename => "../../../config/database.yml"
    assert_response 404
  end
  
  def test_view_theming
    get :static_view_test
    assert_response :success

    assert @response.body =~ /Static View Test from azure/
  end
    
  def disabled_test_javascript
    get :stylesheets, :filename => "typo.js"
    assert_response :success
    assert_equal "text/javascript", @response.headers['Content-Type']
    assert_equal "inline; filename=\"typo.js\"", @response.headers['Content-Disposition']
  end
end