require 'spec_helper'

describe Admin::CategoriesController do
  render_views

  before do
    Factory(:blog)
    request.session = { :user => users(:tobi).id }
  end

  it "test_index" do
    get :index
    assert_response :redirect, :action => 'index'
  end

  it "test_create" do
    lambda do
      post :edit, 'category' => { :name => "test category" }
      assert_response :redirect, :action => 'index'
    end.should change(Category, :count)
  end

  describe "test_new" do
    before(:each) do
      get :new
    end
    
    it 'should render template view' do
      assert_template 'new'
      assert_tag :tag => "div",
        :attributes => { :id => "category_container" }
    end
    
    it 'should have Articles tab selected' do
      test_tabs "Articles"
    end
    
    it 'should have General settings, Write, Feedback, Cache, Users and Redirects with General settings selected' do
      subtabs = ["Articles", "Add new", "Comments", "Categories", "Tags"]
      test_subtabs(subtabs, "Categories")
    end
  end

  describe "test_edit" do
    before(:each) do
      get :edit, :id => Factory(:category).id
    end
    
    it 'should render template new' do
      assert_template 'new'
      assert_tag :tag => "div",
      :attributes => { :id => "category_container" }
    end
    
    it 'should have valid category' do
      assigns(:category).should_not be_nil
      assert assigns(:category).valid?
      assigns(:categories).should_not be_nil
    end
    
    it 'should have Articles tab selected' do
      test_tabs "Articles"
    end
    
    it 'should have General settings, Write, Feedback, Cache, Users and Redirects with no tab selected' do
      subtabs = ["Articles", "Add new", "Comments", "Categories", "Tags"]
      test_subtabs(subtabs, "")
    end    
  end

  it "test_update" do
    post :edit, :id => Factory(:category).id
    assert_response :redirect, :action => 'index'
  end

  describe "test_destroy with GET" do
    before(:each) do
      test_id = Factory(:category).id
      assert_not_nil Category.find(test_id)
      get :destroy, :id => test_id
    end
    
    it 'should render destroy template' do
      assert_response :success
      assert_template 'destroy'      
    end
    
    it 'should have Articles tab selected' do
      test_tabs "Articles"
    end
    
    it 'should have a back to list link' do
      test_back_to_list
    end
  end
  
  it "test_destroy with POST" do
    test_id = Factory(:category).id
    assert_not_nil Category.find(test_id)
    get :destroy, :id => test_id

    post :destroy, :id => test_id
    assert_response :redirect, :action => 'index'

    assert_raise(ActiveRecord::RecordNotFound) { Category.find(test_id) }
  end

  it "test_order" do
    second_cat = Factory(:category, :name => 'b', :position => 1)
    first_cat = Factory(:category, :name => 'a', :position => 3)
    third_cat = Factory(:category, :name => 'c', :position => 2)
    
    assert_equal second_cat, Category.first
    get :order, :category_list => [first_cat.id, second_cat.id, third_cat.id]
    assert_response :success
    assert_equal first_cat, Category.first
  end

  it "test_asort sort by alpha" do
    second_cat = Factory(:category, :name => 'b', :position => 1)
    first_cat = Factory(:category, :name => 'a', :position => 2)
    assert_equal second_cat, Category.first
    get :asort
    assert_response :success
    assert_template "_categories"
    assert_equal first_cat, Category.first
  end

  it "test_category_container" do
    Factory(:category)
    Factory(:category)
    get :category_container
    assert_response :success
    assert_template "_categories"
    assert_tag :tag => "table",
      :children => { :count => Category.count + 2,
        :only => { :tag => "tr" } }
  end

  it "test_reorder" do
    get :reorder
    assert_response :success
    assert_template "reorder"
    assert_select 'ul#category_list > li', Category.count
    assert_select 'a', '(Done)'
  end
end
