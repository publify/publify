require File.dirname(__FILE__) + '/../test_helper'

class SidebarTest < Test::Unit::TestCase
  fixtures :sidebars

  def test_available_sidebars
    assert Sidebar.available_sidebars.size >= 19
  end
end
