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

  def test_setting_booleans_with_integers
    @blog.sp_global = 1
    assert  @blog.sp_global
    @blog.sp_global = 0
    assert !@blog.sp_global
  end

  def test_setting_booleans_with_strings
    {"0 but true" => true, "" => false,
     "false" => false, 1 => true, 0 => false,
     nil => false, 'f' => false }.each do |value, expected|
      @blog.sp_global = value
      assert_equal expected, @blog.sp_global
    end
  end
end
