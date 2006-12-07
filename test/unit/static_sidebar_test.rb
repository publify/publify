require File.dirname(__FILE__) + '/../test_helper'

class StaticSidebarTest < Test::Unit::TestCase
  def test_creation
    assert_kind_of Sidebar, StaticSidebar.new
  end

  def test_default_title
    assert_equal 'Links', StaticSidebar.new.title
  end

  def test_default_body
    assert_equal StaticSidebar::DEFAULT_TEXT, StaticSidebar.new.body
  end

  def test_description
    assert_equal "Static content, like links to other sites, advertisements, or blog meta-information", StaticSidebar.description
  end
end
