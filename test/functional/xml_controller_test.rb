require File.dirname(__FILE__) + '/../test_helper'
require 'xml_controller'

# Re-raise errors caught by the controller.
class XmlController; def rescue_action(e) raise e end; end

class XmlControllerTest < Test::Unit::TestCase
  fixtures :articles, :comments, :trackbacks
  def setup
    @controller = XmlController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_articlerss
    get :articlerss, :id => 1 
    assert_response :success
    assert_nothing_raised do
      assert REXML::Document.new(@response.body)
    end
  end

  def test_commentrss
    get :commentrss
    assert_response :success
    assert_nothing_raised do
      assert REXML::Document.new(@response.body)
    end
  end
  
  def test_trackbackrss
    get :trackbackrss
    assert_response :success
    assert_nothing_raised do
      assert REXML::Document.new(@response.body)
    end
  end  

  def test_rss
    get :rss
    assert_response :success
    assert_nothing_raised do
      assert REXML::Document.new(@response.body)
    end
  end

  def test_atom
    get :atom
    assert_response :success
    assert_nothing_raised do
      assert REXML::Document.new(@response.body)
    end
  end
  
  def test_rsd
    get :rsd, :id => 1 
    assert_response :success
    assert_nothing_raised do
      assert REXML::Document.new(@response.body)
    end
  end  
end
