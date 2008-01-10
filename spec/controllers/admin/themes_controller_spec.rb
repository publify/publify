require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/themes_controller'

# Re-raise errors caught by the controller.
class Admin::ThemesController; def rescue_action(e) raise e end; end

describe Admin::ThemesController, 'ported from the tests' do
  integrate_views

  before do
    request.session = { :user_id => users(:tobi).id }
  end

  # Replace this with your real tests.
  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:themes)
  end

  def test_switchto
    get :switchto, :theme => 'standard_issue'
    assert_response :redirect, :action => 'index'
  end

  def test_preview
    get :preview, :theme => 'standard_issue'
    assert_response :success
  end
end
