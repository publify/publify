require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < Test::Unit::TestCase
  fixtures :comments
  
  def setup
    assert @comment2.save
    assert @spam_comment.save
  end

  def test_article_relation
    assert_equal true, @comment2.has_article?
    assert_equal 1, @comment2.article.id
  end
  
  def test_transformations
    assert_equal HtmlEngine.transform(@comment2.body), @comment2.body_html
  end
  
  def test_url
    assert_equal "http://www.google.com", @comment2.url
  end
  
  def test_nofollow
    assert_equal "Test <a href=\"http://fakeurl.co.uk\" rel=\"nofollow\">body</a>", @spam_comment.body
  end
end
