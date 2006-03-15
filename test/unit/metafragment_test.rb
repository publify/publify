require File.dirname(__FILE__) + '/../test_helper'

class MetaFragmentTest < Test::Unit::TestCase
  include MetaFragmentCache
  include ActionController::Caching::Fragments

  def self.benchmark(foo)
    yield
  end

  def perform_caching
    true
  end

  def setup
  end

  def test_read_write
    data = "BLAHBLAHBLAH"
    meta = {:foo => :bar}
    write_meta_fragment("TESTFRAGMENT", meta, data)
    newmeta, newdata = read_meta_fragment("TESTFRAGMENT")

    assert_equal newdata, data
    assert_equal newmeta, meta

    expire_meta_fragment("TESTFRAGMENT")
  end

  def test_expre_string
    write_meta_fragment("TEST_EXPIRE", {:foo => :bar}, "foo")
    expire_meta_fragment("TEST_EXPIRE")
    meta, data = read_meta_fragment("TEST_EXPIRE")

    assert_equal nil, data
    assert_equal Hash.new, meta
  end

  def test_expire_regex
    write_meta_fragment("TEST_EXPIRE_1", {:a => :b}, "foo")
    write_meta_fragment("TEST_EXPIRE_2", {:c => :d}, "bar")
    write_meta_fragment("TEST_3", {:e => :f}, "zzz")

    expire_meta_fragment(/TEST_EXPIRE.*/)
    assert_equal [Hash.new, nil], read_meta_fragment("TEST_EXPIRE_1")
    assert_equal [Hash.new, nil], read_meta_fragment("TEST_EXPIRE_2")
    assert_equal [{:e => :f},'zzz'], read_meta_fragment("TEST_3")
  end

  def test_read_expires
    key = "TEST_READ_EXPIRES"
    data = "blahblah"
    meta = {:foo => 'bar', :expires => Time.now + 120} # Expire in 2 minutes
    write_meta_fragment(key,meta,data)
    assert_equal [meta, data], read_meta_fragment_expire(key)
    assert_equal [meta, data], read_meta_fragment(key) # It wasn't expired

    meta[:expires] = Time.now - 1
    write_meta_fragment(key,meta,data)
    assert_equal [Hash.new, nil], read_meta_fragment_expire(key)
    assert_equal [Hash.new, nil], read_meta_fragment(key) # It *was* expired
  end
end
