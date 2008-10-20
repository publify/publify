require File.dirname(__FILE__) + '/../../../test/test_helper'
require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/settings_controller'

# Re-raise errors caught by the controller.
class Admin::SettingsController; def rescue_action(e) raise e end; end

describe Admin::SettingsController do
  before do
    request.session = { :user => users(:tobi).id }
  end

  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_read
    get :read
    assert_template 'read'
  end
  
  def test_write
    get :write
    assert_template 'write'
  end
  
  def test_feedback
    get :feedback
    assert_template 'feedback'
  end
  
  def test_seo
    get :seo
    assert_template 'seo'
  end
  
  def test_redirect
    get :redirect
    assert_response :redirect, :controller => 'admin/settings', :action => 'index'
  end
end
