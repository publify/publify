require 'spec_helper'

describe Admin::ResourcesController do
  render_views

  before do
    Factory(:blog)
    @request.session = { :user => users(:tobi).id }
  end

  describe "test_index" do
    before(:each) do
      get :index
    end
    
    it "should render index template" do
      assert_response :success
      assert_template 'index'
      assigns(:resources).should_not be_nil
    end
    
    it 'should have Media tab selected' do
      test_tabs "Media"
    end
    
    it 'should have Library with Library selected' do
      subtabs = ["Library"]
      test_subtabs(subtabs, "Library")
    end
    
  end

  describe "test_destroy_image with get" do
    before(:each) do
      @res_id = Factory(:resource).id
      get :destroy, :id => @res_id
    end
    
    it "should render template destroy" do
      assert_response :success
      assert_template 'destroy'
    end
    
    it 'should have a valid file' do
      assert_not_nil Resource.find(@res_id)
      assert_not_nil assigns(:file)      
    end
    
    it 'should have Media tab selected' do
      test_tabs "Media"
    end
    
    it 'should have a back to list subtab' do
      test_back_to_list
    end
  end
    
  it 'test_destroy_image with POST' do
    res_id = Factory(:resource).id

    post :destroy, :id => res_id
    response.should redirect_to(:action => 'index')
  end

  it "test_upload" do
    # unsure how to test upload constructs :'(
  end
end
