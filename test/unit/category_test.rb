require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < Test::Unit::TestCase
  fixtures :articles, :categories

  def setup
    @category = Category.find(1)
  end

  def test_truth
    assert_kind_of Category,  @category
  end
  
  def test_find_all_with_article_counters
    @software.articles << @article1 << @article2
    @personal.articles << @article3

    c = Category.find_all_with_article_counters

    assert_equal @hardware.articles_count, c[0].article_counter.to_i
    assert_equal @personal.articles_count, c[1].article_counter.to_i
    assert_equal @software.articles_count, c[2].article_counter.to_i
  end
end
