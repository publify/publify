require File.dirname(__FILE__) + '/../test_helper'

require 'http_mock'

class ArticleTest < Test::Unit::TestCase
  fixtures :articles, :settings
  
  def setup
    config.reload
  end
  
  def test_permalink
    assert_equal @article1, Article.find_by_date(2005,01,01)  
    assert_equal @article3, Article.find_by_date(2004,06,01)
    assert_equal [@article1, @article2], Article.find_all_by_date(2005)  
  end

  def test_permalink_with_title
    assert_equal @article2, Article.find_by_permalink(2005, 01, 01, "article-2")  
    assert_nil Article.find_by_permalink(2005, 06, 01, "article-5")  
  end
  
  def test_strip_title
    assert_equal "article-3", "Article-3".to_url
    assert_equal "article-3", "Article 3!?#".to_url
    assert_equal "there-is-sex-in-my-violence", "There is Sex in my Violence!".to_url
    assert_equal "article", "-article-".to_url
    assert_equal "lorem-ipsum-dolor-sit-amet-consectetaur-adipisicing-elit", "Lorem ipsum dolor sit amet, consectetaur adipisicing elit".to_url
    assert_equal "my-cats-best-friend", "My Cat's Best Friend".to_url
  end
  
  def test_perma_title
    assert_equal "article-1", @article1.stripped_title
    assert_equal "article-2", @article2.stripped_title
    assert_equal "article-3", @article3.stripped_title
  end
  
  def test_send_pings
    @article1.send_pings("example.com", "http://localhost/post/5?param=1")
    ping = Net::HTTP.pings.first
    assert_equal "localhost",ping.host
    assert_equal 80, ping.port
    assert_equal "/post/5?param=1", ping.query
    assert_equal "title=Article%201!&excerpt=body&url=example.com&blog_name=test%20blog", ping.post_data
  end


  def test_send_multiple_pings
    @article1.send_pings("example.com", ["http://localhost/post/5?param=1", "http://127.0.0.1/article/5"])
    ping = Net::HTTP.pings[0]
    assert_equal "localhost",ping.host
    assert_equal 80, ping.port
    assert_equal "/post/5?param=1", ping.query
    assert_equal "title=Article%201!&excerpt=body&url=example.com&blog_name=test%20blog", ping.post_data

    ping = Net::HTTP.pings[1]
    assert_equal "127.0.0.1",ping.host
    assert_equal 80, ping.port
    assert_equal "/article/5?", ping.query
    assert_equal "title=Article%201!&excerpt=body&url=example.com&blog_name=test%20blog", ping.post_data
  end
  
end
