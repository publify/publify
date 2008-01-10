require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < Test::Unit::TestCase
  def setup
    @category = Category.find(categories(:software))
  end

  def test_truth
    assert_kind_of Category,  @category
  end

  def test_find_all_with_article_counters
    c = Category.find_all_with_article_counters

    assert_equal categories(:software), c[0]
    assert_equal categories(:hardware), c[1]
    assert_equal categories(:personal), c[2]

    assert_equal 1, c[0].article_counter
    assert_equal 1, c[1].article_counter
    assert_equal 3, c[2].article_counter
  end

  def test_reorder
    assert_equal categories(:software), Category.find(:first, :order => :position)
    Category.reorder([categories(:personal).id, categories(:hardware).id, categories(:software).id])
    assert_equal categories(:personal), Category.find(:first, :order => :position)
  end

  def test_reorder_alpha
    assert_equal categories(:software), Category.find(:first, :order => :position)
    Category.reorder_alpha
    assert_equal categories(:hardware), Category.find(:first, :order => :position)
  end

  def test_permalink
    assert_equal 'http://myblog.net/articles/category/software', @category.permalink_url
  end

end
