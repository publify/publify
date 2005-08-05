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
  end

  def test_list
    get :list
    assert_rendered_file 'list'
    assert_template_has 'categories'
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
    get :edit, 'id' => 1
    assert_rendered_file 'edit'
    assert_template_has 'category'
    assert_valid_record 'category'
  end

  def test_update
    post :edit, 'id' => 1
    assert_redirected_to :action => 'list'
  end

  def test_destroy
    assert_not_nil Category.find(1)

    get :destroy, 'id' => 1
    assert_success
    
    post :destroy, 'id' => 1
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      category = Category.find(1)
    }
  end
end
