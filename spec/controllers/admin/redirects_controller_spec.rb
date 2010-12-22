require 'spec_helper'

describe Admin::RedirectsController do
  render_views

  before do
    request.session = { :user => users(:tobi).id }
  end

  it "test_index" do
    get :index
    assert_template 'index'
    assigns(:redirects).should_not be_nil
  end

  it "test_create" do
    lambda do
      post :edit, 'redirect' => { :from_path => "some/place", 
                                  :to_path => "somewhere/else" }
      assert_response :redirect, :action => 'index'
    end.should change(Redirect, :count)
  end

  it "test_edit" do
    get :edit, :id => Factory(:redirect).id
    assert_template 'new'
    assigns(:redirect).should_not be_nil
    assert assigns(:redirect).valid?
  end

  it "test_update" do
    post :edit, :id => Factory(:redirect).id
    assert_response :redirect, :action => 'index'
  end

  it "test_destroy" do
    test_id = Factory(:redirect).id
    assert_not_nil Redirect.find(test_id)

    get :destroy, :id => test_id
    assert_response :success
    assert_template 'destroy'

    post :destroy, :id => test_id
    assert_response :redirect, :action => 'index'

    assert_raise(ActiveRecord::RecordNotFound) { Category.find(test_id) }
  end
end
