require File.dirname(__FILE__) + '/../test_helper'

class ArticleTest < Test::Unit::TestCase
  fixtures :articles

  # Replace this with your real tests.
  def test_categories
    
    assert_equal ["code", "personal"], Article.categories
  
    Article.destroy_all
    
    assert_equal [], Article.categories
    
  end
end
