require File.dirname(__FILE__) + "/../spec_helper"

describe BlacklistPattern, 'from Test::Unit' do
  before do
    @blacklist_pattern = BlacklistPattern.find(:first)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of BlacklistPattern,  @blacklist_pattern
  end
end
