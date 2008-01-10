require File.dirname(__FILE__) + '/../../../test/test_helper'
require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/settings_controller'

# Re-raise errors caught by the controller.
class Admin::SettingsController; def rescue_action(e) raise e end; end

describe Admin::SettingsController do
  before do
    request.session = { :user_id => users(:tobi).id }
  end

  def test_index
    get :index
    assert_template 'index'
  end

  def test_redirect
    get :redirect
    assert_response :redirect, :controller => 'admin/settings', :action => 'index'
  end
end
