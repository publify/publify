require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < Test::Unit::TestCase
  fixtures :comments
  
  def test_save_regular
    assert @comment2.save
    assert_equal HtmlEngine.transform(@comment2.body), @comment2.body_html
    assert_equal "http://www.google.com", @comment2.url
  end
  
  def test_save_spam
    assert @spam_comment.save
    assert_equal 'Test <a href="http://fakeurl.co.uk" rel="nofollow">body</a>', @spam_comment.body
    assert_equal "http://fakeurl.com", @spam_comment.url
  end

  def test_article_relation
    assert_equal true, @comment2.has_article?
    assert_equal 1, @comment2.article.id
  end
end
