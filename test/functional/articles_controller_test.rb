require File.dirname(__FILE__) + '/../test_helper'
require 'articles_controller'

# Re-raise errors caught by the controller.
class ArticlesController; def rescue_action(e) raise e end; end

class ArticlesControllerTest < Test::Unit::TestCase
  fixtures :articles, :categories, :settings

  def setup
    @controller = ArticlesController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new

    # Complete settings fixtures
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
end
