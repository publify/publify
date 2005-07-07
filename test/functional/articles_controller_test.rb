require File.dirname(__FILE__) + '/../test_helper'
require 'articles_controller'

# Re-raise errors caught by the controller.
class ArticlesController; def rescue_action(e) raise e end; end

class ArticlesControllerTest < Test::Unit::TestCase
  fixtures :articles, :categories, :settings, :users

  def setup
    @controller = ArticlesController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new

    # Complete settings fixtures
    config.reload
  end

  # Category subpages
  def test_category
    get :category, :id => "Software"
    assert_success
    assert_rendered_file "index"
  end
  
  # Main index
  def test_index
    get :index
    assert_success
    assert_rendered_file "index"
  end
  
  # Posts for given day
  def test_find_by_date
    get :find_by_date, :year => 2005, :month => 01, :day => 01
    assert_success
    assert_rendered_file "index"
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
end
