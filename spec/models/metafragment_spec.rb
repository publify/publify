require File.dirname(__FILE__) + '/../spec_helper'
require RAILS_ROOT + '/vendor/plugins/expiring_action_cache/lib/metafragment'

class FragmentCacheTest
  include MetaFragmentCache
  include ActionController::Caching::Fragments

  def self.benchmark(foo)
    yield
  end

  def perform_caching
    true
  end
end

describe 'Just porting metafragment_test without necessarily understanding it' do
  before(:each) { @cache = FragmentCacheTest.new }

  it 'port of test_read_write' do
    data = "BLAHBLAHBLAH"
    meta = {:foo => :bar}

    @cache.write_meta_fragment("TESTFRAGMENT", meta, data)
    newmeta, newdata = @cache.read_meta_fragment("TESTFRAGMENT")
    newdata.should == data
    newmeta.should == meta
  end

  it 'a port of test_expire_string' do
    @cache.write_meta_fragment("TEST_EXPIRE", {:foo => :bar}, "foo")
    @cache.expire_meta_fragment("TEST_EXPIRE")
    meta, data = @cache.read_meta_fragment("TEST_EXPIRE")

    data.should be_nil
    meta.should == { }
  end

  it 'test_expire_regex' do
    @cache.write_meta_fragment("TEST_EXPIRE_1", {:a => :b}, "foo")
    @cache.write_meta_fragment("TEST_EXPIRE_2", {:c => :d}, "bar")
    @cache.write_meta_fragment("TEST_3", {:e => :f}, "zzz")

    @cache.expire_meta_fragment(/TEST_EXPIRE.*/)

    @cache.read_meta_fragment('TEST_EXPIRE_1').should == [{ }, nil]
    @cache.read_meta_fragment('TEST_EXPIRE_2').should == [{ }, nil]
    @cache.read_meta_fragment('TEST_3').should == [{:e => :f}, 'zzz']
  end

  it 'test_read_expires' do
    key = "TEST_READ_EXPIRES"
    data = "blahblah"
    meta = {:foo => 'bar', :expires => Time.now + 120} # Expire in 2 minutes
    @cache.write_meta_fragment(key,meta,data)

    @cache.read_meta_fragment_expire(key).should == [meta, data]
    @cache.read_meta_fragment(key).should == [meta, data] # Time's not up yet.

    meta[:expires] = Time.now - 1
    @cache.write_meta_fragment(key,meta,data)
    @cache.read_meta_fragment_expire(key).should == [{ }, nil]
    @cache.read_meta_fragment(key).should == [{ }, nil] # Definitely expired.
  end
end
