require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/categories_controller'

# Re-raise errors caught by the controller.
class Admin::CategoriesController; def rescue_action(e) raise e end; end

class Admin::CategoriesControllerTest < Test::Unit::TestCase
  fixtures :categories, :users

  def setup
    @controller = Admin::CategoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @request.session = { :user => @tobi }
  end

  def test_index
    get :index
    assert_rendered_file 'list'
    assert_template_has 'categories'
  end

  def test_list
    get :list
    assert_rendered_file 'list'
    assert_template_has 'categories'
    assert_tag :tag => "div",
      :attributes => { :id => "category_container" }
  end
  
  def test_show
    get :show, 'id' => 1
    assert_rendered_file 'show'
    assert_template_has 'category'
    assert_valid_record 'category'
  end

  def test_create
    num_categories = Category.find_all.size

    post :new, 'category' => { :name => "test category" }
    assert_redirected_to :action => 'list'

    assert_equal num_categories + 1, Category.find_all.size
  end

  def test_edit
    get :edit, :id => 1
    assert_rendered_file 'edit'
    assert_template_has 'category'
    assert_valid_record 'category'
  end

  def test_update
    post :edit, :id => 1
    assert_redirected_to :action => 'list'
  end

  def test_destroy
    assert_not_nil Category.find(1)

    get :destroy, :id => 1
    assert_success
    assert_rendered_file 'destroy'
    
    post :destroy, :id => 1
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) { Category.find(1) }
  end

  def test_order
    assert_equal @software, Category.find(:first, :order => :position)
    get :order, :category_list => [@personal.id, @hardware.id, @software.id]
    assert_response :success
    assert_equal @personal, Category.find(:first, :order => :position)
  end
  
  def test_asort
    assert_equal @software, Category.find(:first, :order => :position)
    get :asort
    assert_response :success
    assert_template "_categories"
    assert_equal @hardware, Category.find(:first, :order => :position)
  end
  
  def test_category_container
    get :category_container
    assert_response :success
    assert_template "_categories"
    assert_tag :tag => "table",
      :children => { :count => Category.count + 1,
        :only => { :tag => "tr",
          :children => { :count => 3,
            :only => { :tag => /t[dh]/ } } } }
  end
  
  def test_reorder
    get :reorder
    assert_response :success
    assert_template "reorder"
    assert_tag :tag => "ul",
      :attributes => { :id => "category_list" },
      :children => { :count => Category.count,
        :only => { :tag => "li",
          :attributes => { :id => /category_\d+/ } } }

    assert_tag :tag => "a",
      :content => "(Done)"
  end
end
