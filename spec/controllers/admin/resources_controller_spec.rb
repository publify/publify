require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ResourcesController do
  before do
    @request.session = { :user => users(:tobi).id }
  end

  it "test_index" do
    get :index
    assert_response :success
    assert_template 'index'
    assert_template_has 'resources'
    assert_not_nil assigns(:resources)
  end

  it "test_destroy" do
    res_id = resources(:resource1).id
    assert_not_nil Resource.find(res_id)

    get :destroy, :id => res_id
    assert_response :success
    assert_template 'destroy'
    assert_not_nil assigns(:file)

    post :destroy, :id => res_id
    response.should redirect_to(:action => 'index')
  end

  it "test_upload" do
    # unsure how to test upload constructs :'(
  end
end
