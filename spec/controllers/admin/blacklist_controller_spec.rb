require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::BlacklistController do
  before do
    request.session = { :user => users(:tobi).id }
  end

  it "test_index" do
    get :index
    assert_template 'index'
  end

  it "test_list" do
    get :index
    assert_template 'index'
    assert_template_has 'blacklist_patterns'
  end

  it "test_create" do
    num_blacklist_patterns = BlacklistPattern.count

    post :new, 'blacklist_pattern' => { }
    assert_response :redirect, :action => 'index'

    assert_equal num_blacklist_patterns + 1, BlacklistPattern.count
  end

  it "test_edit" do
    get :edit, 'id' => blacklist_patterns(:first_blacklist_pattern).id
    assert_template 'edit'
    assert_template_has('blacklist_pattern')
    assert assigns(:blacklist_pattern).valid?
  end

  it "test_update" do
    post :edit, 'id' => blacklist_patterns(:first_blacklist_pattern).id
    assert_response :redirect, :action => 'index'
  end

  it "test_destroy" do
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
