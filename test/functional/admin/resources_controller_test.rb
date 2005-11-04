require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/resources_controller'

# Re-raise errors caught by the controller.
class Admin::ResourcesController; def rescue_action(e) raise e end; end

class Admin::ResourcesControllerTest < Test::Unit::TestCase
  fixtures :users, :resources

  def setup
    @controller = Admin::ResourcesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session = { :user => users(:tobi) }
  end

  def test_list
    get :list
    assert_success
    assert_rendered_file 'list'
    assert_template_has 'resources'
    assert_not_nil assigns(:resources)
    assert_not_nil assigns(:resources_pages)
  end
  
  def test_destroy
    assert_not_nil Resource.find(1)

    get :destroy, :id => 1
    assert_success
    assert_rendered_file 'destroy'
    assert_not_nil assigns(:file)
    
    post :destroy, :id => 1
    assert_response 302
    follow_redirect
    assert_rendered_file 'list'
  end

  def test_new
    get :new
    assert_success
    assert_rendered_file 'new'
  end
  
  def test_upload
    # unsure how to test upload constructs :'(
  end
end
