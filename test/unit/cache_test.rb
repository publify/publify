require File.dirname(__FILE__) + '/../test_helper'

class CacheTest < Test::Unit::TestCase
  fixtures :caches

  def setup
    @cache = Cache.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Cache,  @cache
  end
end
