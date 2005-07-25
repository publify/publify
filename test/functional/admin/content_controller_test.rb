require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/content_controller'

# Re-raise errors caught by the controller.
class Admin::ContentController; def rescue_action(e) raise e end; end

class Admin::ContentControllerTest < Test::Unit::TestCase
  fixtures :articles, :users

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
end
