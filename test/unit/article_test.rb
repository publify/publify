require File.dirname(__FILE__) + '/../test_helper'

class ArticleTest < Test::Unit::TestCase
  fixtures :articles

  # Replace this with your real tests.
  def test_permalink
    assert_equal @article1, Article.find_by_date(2005,01,01)  
    assert_equal @article3, Article.find_by_date(2004,06,01)
  end

  def test_permalink_with_title
    assert_equal @article2, Article.find_by_permalink(2005,01,01, "article-2")  
    assert_nil Article.find_by_permalink(2005,01,01, "article-3")  
  end
  
  def test_stip_title
    assert_equal "article-3", Article.strip_title("Article-3")
    assert_equal "article-3", Article.strip_title("Article 3!?#")
    assert_equal "article", Article.strip_title("-article-")
    assert_equal "lorem-ipsum-dolor-sit-amet-consectetaur-adipisicing-elit", Article.strip_title("Lorem ipsum dolor sit amet, consectetaur adipisicing elit")
  end
  
  def test_perma_title
    assert_equal "article-1", @article1.stripped_title
    assert_equal "article-2", @article2.stripped_title
    assert_equal "article-3", @article3.stripped_title
  end
  
end
