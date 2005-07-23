require File.dirname(__FILE__) + '/../test_helper'

class SidebarTest < Test::Unit::TestCase
  fixtures :sidebars

  def setup
    @sidebar = Sidebar.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Sidebar,  @sidebar
  end
end
