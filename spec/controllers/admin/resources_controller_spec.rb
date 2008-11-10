require File.dirname(__FILE__) + '/../../../test/test_helper'
require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/resources_controller'

# Re-raise errors caught by the controller.
class Admin::ResourcesController; def rescue_action(e) raise e end; end

describe Admin::ResourcesController do
  before do
    @request.session = { :user => users(:tobi).id }
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'index'
    assert_template_has 'resources'
    assert_not_nil assigns(:resources)
  end

  def test_destroy
    res_id = resources(:resource1).id
    assert_not_nil Resource.find(res_id)

    get :destroy, :id => res_id
    assert_response :success
    assert_template 'destroy'
    assert_not_nil assigns(:file)

    post :destroy, :id => res_id
    response.should redirect_to(:action => 'index')
  end

  def test_new
    get :new
    assert_response :success
    assert_template 'new'
  end

  def test_upload
    # unsure how to test upload constructs :'(
  end
end
