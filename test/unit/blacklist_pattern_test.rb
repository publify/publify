require File.dirname(__FILE__) + '/../test_helper'

class BlacklistPatternTest < Test::Unit::TestCase
  def setup
    @blacklist_pattern = BlacklistPattern.find(:first)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of BlacklistPattern,  @blacklist_pattern
  end
end
