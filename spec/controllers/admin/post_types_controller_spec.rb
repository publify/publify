require 'spec_helper'

describe Admin::PostTypesController do
  render_views
  before do 
    FactoryGirl.create(:blog)
    #TODO delete this after remove fixture
    Profile.delete_all
    @user = FactoryGirl.create(:user, :profile => FactoryGirl.create(:profile_admin, :label => Profile::ADMIN))
    request.session = { :user => @user.id }
  end

  it "index shoudld redirect to new" do
    get :index
    assert_response :redirect, :action => 'new'
  end

  it "test_create" do
    pt = FactoryGirl.create(:post_type)
    PostType.should_receive(:find).with(:all).and_return([])
    PostType.should_receive(:new).and_return(pt)
    pt.should_receive(:save!).and_return(true)
    post :edit, 'post_type' => { :name => "new post type" }
    assert_response :redirect
    assert_redirected_to :action => 'index'
  end

  describe "test_new" do
    before(:each) do
      get :new
    end

    it 'should render template new' do
      assert_template 'new'
    end

  end

  describe "test_edit" do
    it 'should render template new' do
      get :edit, :id => FactoryGirl.build(:post_type).id
      assert_template 'new'
    end
      
    it "test_update" do
      post :edit, :id => FactoryGirl.create(:post_type).id
      assert_response :redirect, :action => 'index'
    end
  end
    
  describe "test_destroy with GET" do
    before(:each) do
      test_id = FactoryGirl.create(:post_type).id
      assert_not_nil PostType.find(test_id)
      get :destroy, :id => test_id
    end

    it 'should render destroy template' do
      assert_response :success
      assert_template 'destroy'      
    end
  end

  it "test_destroy with POST" do
    test_id = FactoryGirl.create(:post_type).id
    assert_not_nil PostType.find(test_id)
    get :destroy, :id => test_id

    post :destroy, :id => test_id
    assert_response :redirect, :action => 'index'

    assert_raise(ActiveRecord::RecordNotFound) { PostType.find(test_id) }
  end
 

end
