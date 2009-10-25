require File.dirname(__FILE__) + "/../spec_helper"

describe BlacklistPattern, 'from Test::Unit' do
  before do
    @blacklist_pattern = BlacklistPattern.find(:first)
  end

  # Replace this with your real tests.
  it "test_truth" do
    assert_kind_of BlacklistPattern,  @blacklist_pattern
  end
end
