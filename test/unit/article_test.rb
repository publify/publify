require File.dirname(__FILE__) + '/../test_helper'

require 'http_mock'

class ArticleTest < Test::Unit::TestCase
  fixtures :articles, :settings, :articles_tags, :tags, :resources
  
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
  
  def test_tags
    a=Article.new(:title => 'Test tag article',
                     :keywords => 'test tag tag stuff');

    assert_kind_of Article, a
    assert_equal 0, a.tags.size

    a.keywords_to_tags
    
    assert_equal 3, a.tags.size
    assert_equal ["test", "tag", "stuff"].sort , a.tags.collect {|t| t.name}.sort
    assert a.save

    a.keywords='tag bar stuff foo'
    a.keywords_to_tags

    assert_equal 4, a.tags.size
    assert_equal ["foo", "bar", "tag", "stuff"].sort , a.tags.collect {|t| t.name}.sort
    
    a.keywords='tag bar'
    a.keywords_to_tags
    
    assert_equal 2, a.tags.size
    
    a.keywords=''
    a.keywords_to_tags
    
    assert_equal 0, a.tags.size

    b=Article.new(:title => 'Tag Test 2',
                  :keywords => 'tag test article one two three')

    assert_kind_of Article,b
    assert 0, b.tags.size
    assert a.save
    assert 5, b.tags.size
  end

  def test_find_by_tag
    articles=Article.find_by_tag(@foo_tag.name)

    assert 2, articles.size
    assert [@article1, @article2].sort_by {|a| a.id}, articles.sort_by {|a| a.id}
  end

  def test_destroy_file_upload_associations
    @article1.resources << @resource1 << @resource2
    assert_equal 2, @article1.resources.size
    @article1.destroy
    assert_equal 0, Resource.find(:all, :conditions => "article_id = #{@article1.id}").size
  end
end
