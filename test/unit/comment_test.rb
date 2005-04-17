require File.dirname(__FILE__) + '/../test_helper'

require 'dns_mock'

class CommentTest < Test::Unit::TestCase
  fixtures :articles, :comments, :blacklist_patterns, :settings

  def setup
    config.reload
  end

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
  
  def test_reject_spam_rbl
    c = Comment.new
    c.author "Spammer"
    c.body = %{This is just some random text. <a href="http://chinaaircatering.com">without any senses.</a>. Please disregard.}
    c.url = "http://buy-computer.us"
    c.ip = "212.42.230.206"

    assert ! c.save
    assert c.errors.invalid?('body')
    assert c.errors.invalid?('url')
  end

  def test_reject_spam_pattern
    c = Comment.new
    c.author = "Another Spammer"
    c.body = "Texas hold-em poker crap"
    c.url = "http://texas.hold-em.us"
    
    assert ! c.save
    assert c.errors.invalid?('body')
  end
  
  def test_reject_spam_uri_limit
    c = Comment.new
    c.author = "Yet Another Spammer"
    c.body = %{ <a href="http://www.one.com/">one</a> <a href="http://www.two.com/">two</a> <a href="http://www.three.com/">three</a> <a href="http://www.four.com/">four</a> }
    c.url = "http://www.uri-limit.com"
    c.ip = "123.123.123.123"
    
    assert ! c.save
    assert c.errors.invalid?('body')
  end

  def test_reject_article_age
    c = Comment.new
    c.author = "Old Spammer"
    c.body = "Old trackback body"
    c.article = @article3

    assert ! c.save
    assert c.errors.invalid?('article_id')
      
    c.article = @article1
      
    assert c.save
    assert c.errors.empty?
  end

  def test_article_relation
    assert_equal true, @comment2.has_article?
    assert_equal 1, @comment2.article.id
  end
end
