require File.dirname(__FILE__) + "/../spec_helper"

class RouteCacheTest < Test::Unit::TestCase

  def test_cache_clear
    RouteCache[:foo] = :bar
    RouteCache.clear
    assert_equal({}, RouteCache.instance_variable_get(:@cache))
  end

end
