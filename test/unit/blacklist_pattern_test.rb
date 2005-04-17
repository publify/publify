require File.dirname(__FILE__) + '/../test_helper'

class BlacklistPatternTest < Test::Unit::TestCase
  fixtures :blacklist_patterns

  def setup
    @blacklist_pattern = BlacklistPattern.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of BlacklistPattern,  @blacklist_pattern
  end
end
