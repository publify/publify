require 'test/unit'
require File.dirname(__FILE__) + '/../../../../test/test_helper'

class AimpresenceSidebarTest < Test::Unit::TestCase
  def setup
    @sidebar = AimpresenceSidebar.new
  end

  def test_sidebar_is_available
    assert Sidebar.available_sidebars.include?( AimpresenceSidebar )
  end

  def test_display_name
    assert_equal 'AIM Presence', AimpresenceSidebar.display_name
  end

  def test_description
    assert_equal <<EOS, AimpresenceSidebar.description
Displays the Online presence of an AOL Instant Messenger screen name<br/>
If you don\'t have a key, register <a href="http://www.aim.com/presence">here</a>.
EOS
  end

  def test_sn
    assert_equal '', @sidebar.sn
    assert_equal 'Screen Name', @sidebar.fieldmap(:sn).label
  end

  def test_devkey
    assert_equal '', @sidebar.devkey
    assert_equal 'Key', @sidebar.fieldmap(:devkey).label
  end
end
