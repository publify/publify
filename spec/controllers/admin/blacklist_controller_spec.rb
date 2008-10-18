require File.dirname(__FILE__) + '/../../../test/test_helper'
require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/blacklist_controller'

# Re-raise errors caught by the controller.
class Admin::BlacklistController; def rescue_action(e) raise e end; end

describe Admin::BlacklistController do
  before do
    request.session = { :user => users(:tobi).id }
  end

  def test_index
    get :index
    assert_template 'index'
  end

  def test_list
    get :index
    assert_template 'index'
    assert_template_has 'blacklist_patterns'
  end

  def test_create
    num_blacklist_patterns = BlacklistPattern.count

    post :new, 'blacklist_pattern' => { }
    assert_response :redirect, :action => 'index'

    assert_equal num_blacklist_patterns + 1, BlacklistPattern.count
  end

  def test_edit
    get :edit, 'id' => blacklist_patterns(:first_blacklist_pattern).id
    assert_template 'edit'
    assert_template_has('blacklist_pattern')
    assert_valid assigns(:blacklist_pattern)
  end

  def test_update
    post :edit, 'id' => blacklist_patterns(:first_blacklist_pattern).id
    assert_response :redirect, :action => 'index'
  end

  def test_destroy
    pattern_id = blacklist_patterns(:first_blacklist_pattern).id
    assert_not_nil BlacklistPattern.find(pattern_id)

    get :destroy, 'id' => pattern_id
    assert_response :success

    post :destroy, 'id' => pattern_id
    assert_response :redirect, :action => 'index'

    assert_raise(ActiveRecord::RecordNotFound) {
      blacklist_pattern = BlacklistPattern.find(pattern_id)
    }
  end
end
