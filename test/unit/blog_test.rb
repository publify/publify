require File.dirname(__FILE__) + '/../test_helper'

class BlogTest < Test::Unit::TestCase
  fixtures :blogs, :contents, :sidebars

  def setup
    @blog = Blog.find(:first)
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

  def test_current_theme_path
    assert_equal Theme.themes_root + "/standard_issue", @blog.current_theme.path
  end

  def test_current_theme
    assert_equal "standard_issue", @blog.current_theme.name
  end

  def test_url_for
    assert_equal('http://myblog.net/articles/read/1',
                 @blog.url_for(:controller => 'articles',
                               :action     => 'read',
                               :id         => 1))
  end

  def test_blog_has_sidebars
    assert_equal 1, @blog.sidebars.size
  end
end
