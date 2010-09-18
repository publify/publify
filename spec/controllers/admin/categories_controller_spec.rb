require 'spec_helper'

describe Admin::CategoriesController do
  render_views

  before do
    request.session = { :user => users(:tobi).id }
  end

  it "test_index" do
    get :index
    assert_template 'index'
    assert_template_has 'categories'
    assert_tag :tag => "div",
      :attributes => { :id => "category_container" }
  end

  it "test_create" do
    assert_difference 'Category.count' do
      post :edit, 'category' => { :name => "test category" }
      assert_response :redirect, :action => 'index'
    end
  end

  it "test_edit" do
    get :edit, :id => Factory(:category).id
    assert_template 'new'
    assert_template_has 'category'
    assert assigns(:category).valid?
  end

  it "test_update" do
    post :edit, :id => Factory(:category).id
    assert_response :redirect, :action => 'index'
  end

  it "test_destroy" do
    test_id = Factory(:category).id
    assert_not_nil Category.find(test_id)

    get :destroy, :id => test_id
    assert_response :success
    assert_template 'destroy'

    post :destroy, :id => test_id
    assert_response :redirect, :action => 'index'

    assert_raise(ActiveRecord::RecordNotFound) { Category.find(test_id) }
  end

  it "test_order" do
    second_cat = Factory(:category, :name => 'b')
    first_cat = Factory(:category, :name => 'a')
    third_cat = Factory(:category, :name => 'c')
    assert_equal second_cat, Category.find(:first, :order => :position)
    get :order, :category_list => [first_cat.id, second_cat.id, third_cat.id]
    assert_response :success
    assert_equal first_cat, Category.find(:first, :order => :position)
  end

  it "test_asort sort by alpha" do
    second_cat = Factory(:category, :name => 'b')
    first_cat = Factory(:category, :name => 'a')
    assert_equal second_cat, Category.find(:first, :order => :position)
    get :asort
    assert_response :success
    assert_template "_categories"
    assert_equal first_cat, Category.find(:first, :order => :position)
  end

  it "test_category_container" do
    Factory(:category)
    Factory(:category)
    get :category_container
    assert_response :success
    assert_template "_categories"
    assert_tag :tag => "table",
      :children => { :count => Category.count + 2,
        :only => { :tag => "tr",
          :children => { :count => 1 } } }
  end

  it "test_reorder" do
    get :reorder
    assert_response :success
    assert_template "reorder"
    assert_select 'ul#category_list > li', Category.count
    assert_select 'a', '(Done)'
  end
end
