require File.dirname(__FILE__) + "/../spec_helper"

class SidebarTest < Test::Unit::TestCase
  def test_available_sidebars
    assert Sidebar.available_sidebars.size >= 6
  end
end
