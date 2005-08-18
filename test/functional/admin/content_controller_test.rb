require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/content_controller'

# Re-raise errors caught by the controller.
class Admin::ContentController; def rescue_action(e) raise e end; end

class Admin::ContentControllerTest < Test::Unit::TestCase
  fixtures :articles, :users, :categories, :resources

  def setup
    @controller = Admin::ContentController.new
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
    assert_template_has 'articles'
  end

  def test_show
    get :show, 'id' => 1
    assert_rendered_file 'show'
    assert_template_has 'article'
    assert_valid_record 'article'
    assert_not_nil assigns(:article)
    assert_not_nil assigns(:categories)
    assert_not_nil assigns(:resources)
  end

  def test_new
    get :new
    assert_rendered_file 'new'
    assert_template_has 'article'
  end

  def test_create
    num_articles = Article.find_all.size

    post :new, 'article' => { :title => "posted via tests!" }
    assert_redirected_to :action => 'show'

    assert_equal num_articles + 1, Article.find_all.size

    new_article = Article.find(:first, :order => "id DESC")
    assert_equal @tobi, new_article.user
  end

  def test_edit
    get :edit, 'id' => 1
    assert_rendered_file 'edit'
    assert_template_has 'article'
    assert_valid_record 'article'
  end

  def test_update
    post :edit, 'id' => 1
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Article.find(1)

    get :destroy, 'id' => 1
    assert_success
    
    post :destroy, 'id' => 1
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      article = Article.find(1)
    }
  end

  def test_category_add
    get :category_add, :id => 1, :category_id => 1
    
    assert_rendered_file '_show_categories'
    assert_valid_record 'article'
    assert_valid_record 'category'
    assert Article.find(1).categories.include?(Category.find(1))
    assert_not_nil assigns(:article)
    assert_not_nil assigns(:category)
    assert_not_nil assigns(:categories)
  end

  def test_category_remove
    get :category_remove, :id => 1, :category_id => 1
    
    assert_rendered_file '_show_categories'
    assert_valid_record 'article'
    assert_valid_record 'category'
    assert !Article.find(1).categories.include?(Category.find(1))
    assert_not_nil assigns(:article)
    assert_not_nil assigns(:category)
    assert_not_nil assigns(:categories)
  end

  def test_resource_add
    get :resource_add, :id => 1, :resource_id => 1
    
    assert_rendered_file '_show_resources'
    assert_valid_record 'article'
    assert_valid_record 'resource'
    assert Article.find(1).resources.include?(Resource.find(1))
    assert_not_nil assigns(:article)
    assert_not_nil assigns(:resource)
    assert_not_nil assigns(:resources)
  end

  def test_resource_remove
    get :resource_remove, :id => 1, :resource_id => 1
    
    assert_rendered_file '_show_resources'
    assert_valid_record 'article'
    assert_valid_record 'resource'
    assert !Article.find(1).resources.include?(Resource.find(1))
    assert_not_nil assigns(:article)
    assert_not_nil assigns(:resource)
    assert_not_nil assigns(:resources)
  end

  def test_attachment_box_add
    get :attachment_box_add, :id => 2
    assert_rendered_file '_attachment'
    #assert_tag :tag => 'script'
  end
  
  def test_attachment_box_remove
    get :attachment_box_remove, :id => 1
    assert_tag :tag => 'script', :attributes => {:type => 'text/javascript'}
  end
end
