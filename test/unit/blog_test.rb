require File.dirname(__FILE__) + '/../test_helper'

class BlogTest < Test::Unit::TestCase
  fixtures :blogs

  def setup
    @blog = Blog.find(:first)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Blog, blogs(:default)
  end

  def test_blog_name
    assert_equal "test blog", @blog.blog_name
  end

  def test_default_allow_pings
    assert ! @blog.default_allow_pings?
  end
end
