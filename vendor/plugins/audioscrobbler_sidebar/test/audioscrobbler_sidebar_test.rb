require 'test/unit'
require File.dirname(__FILE__) + '/../../../../test/test_helper'

class AudioscrobblerSidebarTest < Test::Unit::TestCase
  def test_sidebar_is_available
    assert Sidebar.available_sidebars.include?(AudioscrobblerSidebar)
  end
end
