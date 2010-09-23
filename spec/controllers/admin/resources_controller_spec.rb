require 'spec_helper'

describe Admin::ResourcesController do
  before do
    @request.session = { :user => users(:tobi).id }
  end

  it "test_index" do
    get :index
    assert_response :success
    assert_template 'index'
    assigns(:resources).should_not be_nil
  end

  it "test_images" do
    get :images
    assert_response :success
    assert_template 'images'
    assigns(:resources).should_not be_nil
  end

  it "test_destroy_image" do
    res_id = Factory(:resource).id
    assert_not_nil Resource.find(res_id)

    get :destroy, :id => res_id
    assert_response :success
    assert_template 'destroy'
    assert_not_nil assigns(:file)

    post :destroy, :id => res_id
    response.should redirect_to(:action => 'images')
  end

  it "test_destroy_regular_file" do
    res_id = Factory(:resource, :mime => 'text/plain').id
    assert_not_nil Resource.find(res_id)

    get :destroy, :id => res_id
    assert_response :success
    assert_template 'destroy'
    assert_not_nil assigns(:file)

    post :destroy, :id => res_id
    assert_response :redirect
    response.should redirect_to(:action => 'index')
  end

  it "test_upload" do
    # unsure how to test upload constructs :'(
  end
end
