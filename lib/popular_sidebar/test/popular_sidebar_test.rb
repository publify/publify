require 'test/unit'
require File.dirname(__FILE__) + '/../../../../test/test_helper'

class PopularSidebarTest < Test::Unit::TestCase
  def test_popular_is_available
    assert Sidebar.available_sidebars.include?(PopularSidebar)
  end
end
