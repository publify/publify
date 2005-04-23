require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < Test::Unit::TestCase
  fixtures :categories

  def setup
    @category = Category.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Category,  @category
  end
end
