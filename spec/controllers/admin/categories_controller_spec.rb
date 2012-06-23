require 'spec_helper'

describe Admin::CategoriesController do
  render_views

  before(:each) do
    FactoryGirl.create(:blog)
    #TODO Delete after removing fixtures
    Profile.delete_all
    henri = FactoryGirl.create(:user, :login => 'henri', :profile => FactoryGirl.create(:profile_admin, :label => Profile::ADMIN))
    request.session = { :user => henri.id }
  end

  it "test_index" do
    get :index
    assert_response :redirect, :action => 'index'
  end

  it "test_create" do
    cat = FactoryGirl.create(:category)
    Category.should_receive(:find).with(:all).and_return([])
    Category.should_receive(:new).and_return(cat)
    cat.should_receive(:save!).and_return(true)
    post :edit, 'category' => { :name => "test category" }
    assert_response :redirect
    assert_redirected_to :action => 'new'
  end

  describe "test_new" do
    before(:each) do
      get :new
    end

    it 'should render template view' do
      assert_template 'new'
      assert_tag :tag => "table",
        :attributes => { :id => "category_container" }
    end
  end

  describe "test_edit" do
    before(:each) do
      get :edit, :id => FactoryGirl.create(:category).id
    end

    it 'should render template new' do
      assert_template 'new'
      assert_tag :tag => "table",
        :attributes => { :id => "category_container" }
    end

    it 'should have valid category' do
      assigns(:category).should_not be_nil
      assert assigns(:category).valid?
      assigns(:categories).should_not be_nil
    end
  end

  it "test_update" do
    post :edit, :id => FactoryGirl.create(:category).id
    assert_response :redirect, :action => 'index'
  end

  describe "test_destroy with GET" do
    before(:each) do
      test_id = FactoryGirl.create(:category).id
      assert_not_nil Category.find(test_id)
      get :destroy, :id => test_id
    end

    it 'should render destroy template' do
      assert_response :success
      assert_template 'destroy'      
    end
  end

  it "test_destroy with POST" do
    test_id = FactoryGirl.create(:category).id
    assert_not_nil Category.find(test_id)
    get :destroy, :id => test_id

    post :destroy, :id => test_id
    assert_response :redirect, :action => 'index'

    assert_raise(ActiveRecord::RecordNotFound) { Category.find(test_id) }
  end
  
end
