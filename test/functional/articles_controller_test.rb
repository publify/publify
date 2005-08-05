require File.dirname(__FILE__) + '/../test_helper'
require 'articles_controller'

# Re-raise errors caught by the controller.
class ArticlesController; def rescue_action(e) raise e end; end

class ArticlesControllerTest < Test::Unit::TestCase
  fixtures :articles, :categories, :settings, :users, :comments, :trackbacks, :pages, :articles_categories

  def setup
    @controller = ArticlesController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new

    # Complete settings fixtures
    config.reload
  end

  # Category subpages
  def test_category
    get :category, :id => "software"

    assert_response :success
    assert_rendered_file "index"
  end
  
  # Main index
  def test_index
    get :index
    assert_response :success
    assert_rendered_file "index"
  end
  
  # Archives page
  def test_archives
    get :archives
    assert_response :success
    assert_rendered_file "archives"
  end
  
  # Permalinks
  def test_permalink
    get :permalink, :year => 2005, :month => 01, :day => 01, :title => "article-1"
    assert_response :success
    assert_template "read"
    assert_not_nil assigns(:article)
    assert_equal @article1, assigns(:article)
  end

  # Posts for given day
  def test_find_by_date
    get :find_by_date, :year => 2005, :month => 01, :day => 01
    assert_response :success
    assert_rendered_file "index"
  end
  
  def test_comment_nuking 
    num_comments = Comment.count
    post :nuke_comment, { :id => 1 }, {}
    assert_response 403

    get :nuke_comment, { :id => 1 }, { :user => users(:bob)}
    assert_response 403
      
    post :nuke_comment, { :id => 1 }, { :user => users(:bob)}
    assert_response :success
    assert_equal num_comments -1, Comment.count    
  end

  def test_trackback_nuking 
    num_comments = Trackback.count

    post :nuke_trackback, { :id => 1 }, {}
    assert_response 403

    get :nuke_trackback, { :id => 1 }, { :user => users(:bob)}
    assert_response 403

    post :nuke_trackback, { :id => 1 }, { :user => users(:bob)}
    assert_response :success
    assert_equal num_comments -1, Trackback.count    
  end
  
  def test_no_settings
    Setting.destroy_all
    assert Setting.count.zero?
    
    # save this because the AWS stuff needs it later
    old_config = $config
    $config = nil

    get :index
    
    assert_redirect
    assert_redirected_to :controller => "admin/general", :action => "index"
    
    # reassign so the AWS stuff doesn't barf
    $config = old_config
  end
  
  def test_no_users_exist
    Setting.destroy_all
    assert Setting.count.zero?

    # save this because the AWS stuff needs it later
    old_config = $config
    $config = nil

    User.destroy_all
    assert User.count.zero?
    
    get :index
    assert_redirect
    assert_redirected_to :controller => "accounts", :action => "signup"

    # reassign so the AWS stuff doesn't barf
    $config = old_config
  end

  def test_pages_static
    get :view_page, :name => 'page_one'
    assert_response :success
    assert_rendered_file "view_page"
    
    get :view_page, :name => 'page one'
    assert_response 404
  end
end
