require File.dirname(__FILE__) + "/../spec_helper"

class TypoDeprecatedTest < Test::Unit::TestCase
  class TestMe
    attr_accessor :one, :two, :three
    typo_deprecate :a => :one, :b => :two
  end

  def test_typo_deprecate
    t = TestMe.new
    t.should_receive(:typo_deprecated).with("Use one instead of a").once
    t.should_receive(:typo_deprecated).with("Use two instead of b").once
    t.should_receive(:one).once
    t.should_receive(:two).once
    t.a
    t.b
  end
end
