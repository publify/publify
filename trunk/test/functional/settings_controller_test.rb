require File.dirname(__FILE__) + '/../test_helper'
require 'settings_controller'

# Re-raise errors caught by the controller.
class SettingsController; def rescue_action(e) raise e end; end

class SettingsControllerTest < Test::Unit::TestCase
  def setup
    @controller = SettingsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_index
    
    
  end
end
