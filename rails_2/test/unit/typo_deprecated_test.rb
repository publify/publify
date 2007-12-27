require File.dirname(__FILE__) + '/../test_helper'

class TypoDeprecatedTest < Test::Unit::TestCase
  include FlexMock::TestCase
  
  class TestMe
    attr_accessor :one, :two, :three
    typo_deprecate :a => :one, :b => :two
  end
  
  def test_typo_deprecate
    t = TestMe.new
    flexmock(t) do |mock|
      mock.should_receive(:typo_deprecated).with("Use one instead of a").once
      mock.should_receive(:typo_deprecated).with("Use two instead of b").once
      mock.should_receive(:one).once
      mock.should_receive(:two).once
    end
    t.a
    t.b
  end
end
