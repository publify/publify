require File.dirname(__FILE__) + '/../test_helper'

class SettingTest < Test::Unit::TestCase
  fixtures :settings

  def setup
    @setting = Setting.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Setting, @setting
  end
end
