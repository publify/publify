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

    assert_equal @software, c[0]
    assert_equal @hardware, c[1]
    assert_equal @personal, c[2]

    assert_equal @software.articles_count, c[0].article_counter.to_i
    assert_equal @hardware.articles_count, c[1].article_counter.to_i
    assert_equal @personal.articles_count, c[2].article_counter.to_i
  end

  def test_reorder
    assert_equal @software, Category.find(:first, :order => :position)
    Category.reorder([@personal.id, @hardware.id, @software.id])
    assert_equal @personal, Category.find(:first, :order => :position)
  end
  
  def test_reorder_alpha
    assert_equal @software, Category.find(:first, :order => :position)
    Category.reorder_alpha
    assert_equal @hardware, Category.find(:first, :order => :position)
  end
end
