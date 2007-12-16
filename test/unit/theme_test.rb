require File.dirname(__FILE__) + '/../test_helper'
require 'theme'
require 'theme_mock'

class ThemeTest < Test::Unit::TestCase
  fixtures :blogs

  def setup
    @theme = Theme.new("test", "test")
  end

  def test_layout
    assert_equal "../../themes/test/layouts/default", @theme.layout
  end

  def test_description
    # Filtering now occurs in the controller, not the model
    assert_equal "### Standard Issue by [NodeThirtyThree][1]\n\nStandard issue is the new default Typo theme starting Typo 5.0\n\n[1]: http://www.nodethirtythree.com/\n",
      this_blog.current_theme.description
  end

  def test_themes_root
    # Overridden in theme_mock
    assert_equal RAILS_ROOT + "/test/mocks/themes", Theme.themes_root
  end

  def test_theme_from_path
    assert_equal "standard_issue", Theme.theme_from_path(this_blog.current_theme.path).name
  end

  def test_search_theme_directory
    assert_equal %w{ 123-numbers-in-path CamelCaseDirectory i-have-special-chars standard_issue },
      Theme.search_theme_directory.collect { |t| File.basename(t) }.sort
  end

  def test_installed_themes
    assert_equal Theme.installed_themes, Theme.search_theme_directory
  end

  def test_find_all
    assert Theme.find_all.collect { |t| t.name }.include?(this_blog.current_theme.name)
    assert_equal 4, Theme.find_all.size
  end
end
