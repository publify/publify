require 'rubygems'
require 'test/unit'
require 'test/zentest_assertions'

$TESTING = true
$TESTING_CM = true

RAILS_ENV = 'production'

module Rails; end
module Rails::VERSION
  MAJOR = 1
  MINOR = 1
  TINY = 2
end

module ActiveRecord; end

class ActiveRecord::Base

  @count = 1000

  attr_accessor :id, :attributes

  def self.abstract_class=(arg)
    @abstract_class = arg
  end

  def self.abstract_class?
    @abstract_class ||= false
    return !!@abstract_class
  end

  ##
  # Need doco, blech

  def self.find(*args)
    args.flatten!
    case args.first
    when :first then
      return find(:all, *args).first
    when :all then
      return find_by_sql("SELECT * FROM #{table_name} WHERE (#{table_name}.#{primary_key} = '#{args.last}')  LIMIT 1")
    else
      case args.length
      when 1 then
        return find(:first, *args) if Fixnum === args.first
        raise "Dunno what to do"
      when 2 then
        return find(args.first) if Hash === args.last
        return new
      when 3 then
        return [new, new, new]
      else
        raise "Dunno what to do"
      end
    end
  end

  def self.find_by_sql(query)
    return [] if query =~ /concrete\.id = -1/
    return [new]
  end

  def self.next_id
    @count += 1
    return @count
  end

  def self.table_name
    name.downcase
  end

  def self.transaction(*a)
    yield
  end

  def self.primary_key
    'id'
  end

  def initialize
    @id = ActiveRecord::Base.next_id
    @attributes = { :data => 'data' }
  end

  def ==(other)
    self.class == other.class and
    id == other.id and
    attributes_before_type_cast == other.attributes_before_type_cast
  end

  def attributes_before_type_cast
    { :data => @attributes[:data] }
  end

  def destroy
  end

  def reload
    @attributes[:data].succ!
    @attributes[:extra] = nil
  end

  def save
    update
  end

  def transaction(*a, &b)
    self.class.transaction(*a, &b)
  end

  def update
  end

end

require 'cached_model'

class Concrete < CachedModel; end
class STILameness < Concrete; end

module Cache

  @cache = {}
  @ttl = {}

  class << self; attr_accessor :cache, :ttl; end

  def self.delete(key)
    @cache.delete key
    @ttl.delete key
    return nil
  end

  def self.get(key)
    @cache[key]
  end

  def self.put(key, value, ttl)
    value = Marshal.load Marshal.dump(value)
    @cache[key] = value
    @ttl[key] = ttl
  end

end

class << CachedModel

  attr_writer :cache_local
  attr_writer :cache_delay_commit

end

class TestCachedModel < Test::Unit::TestCase

  DEFAULT_USE_LOCAL_CACHE = CachedModel.use_local_cache?
  DEFAULT_USE_MEMCACHE = CachedModel.use_memcache?

  def setup
    @model = Concrete.new
    Cache.cache = {}
    Cache.ttl = {}
    CachedModel.cache_delay_commit = {}
    CachedModel.cache_local = {}
    CachedModel.use_local_cache = DEFAULT_USE_LOCAL_CACHE
    CachedModel.use_memcache = DEFAULT_USE_MEMCACHE
  end

  def teardown
    CachedModel.use_local_cache = DEFAULT_USE_LOCAL_CACHE
    CachedModel.use_memcache = DEFAULT_USE_MEMCACHE
  end

  def test_class_abstract_class_eh
    assert_equal true, CachedModel.abstract_class?, 'CachedModel is abstract'
    assert_equal false, Concrete.abstract_class?, 'Concrete is not abstract'
  end

  def test_class_cache_delete
    CachedModel.use_local_cache = true
    CachedModel.use_memcache = true
    util_set

    CachedModel.cache_delete @model.class, @model.id

    assert_empty CachedModel.cache_local
    assert_empty Cache.cache
  end

  def test_class_cache_delete_without_local_cache
    CachedModel.use_local_cache = false
    CachedModel.use_memcache = true
    util_set

    CachedModel.cache_delete @model.class, @model.id

    deny_empty CachedModel.cache_local
    assert_empty Cache.cache
  end

  def test_class_cache_delete_without_memcache
    CachedModel.use_local_cache = true
    CachedModel.use_memcache = false
    util_set

    CachedModel.cache_delete @model.class, @model.id

    assert_empty CachedModel.cache_local
    deny_empty Cache.cache
  end

  def test_class_cache_reset
    CachedModel.use_local_cache = true
    CachedModel.use_memcache = true
    util_set

    CachedModel.cache_reset
    
    assert_empty CachedModel.cache_local
    deny_empty Cache.cache
  end

  def test_class_cache_reset_without_local_cache
    CachedModel.use_local_cache = false
    CachedModel.use_memcache = true
    util_set

    CachedModel.cache_reset
    
    deny_empty CachedModel.cache_local
    deny_empty Cache.cache
  end

  def test_class_cache_reset_without_memcache
    CachedModel.use_local_cache = true
    CachedModel.use_memcache = false
    util_set

    CachedModel.cache_reset
    
    assert_empty CachedModel.cache_local
    deny_empty Cache.cache
  end

  def test_class_find_complex
    CachedModel.use_local_cache = true
    CachedModel.use_memcache = true

    record = Concrete.find(1, :order => 'lock_version')

    assert_equal @model.id + 1, record.id

    assert_equal record, util_local(record)
    assert_equal record, util_memcache(record)
  end

  def test_class_find_complex_without_local_cache
    CachedModel.use_local_cache = false
    CachedModel.use_memcache = true

    record = Concrete.find(1, :order => 'lock_version')

    assert_equal @model.id + 1, record.id

    assert_equal nil, util_local(record)
    assert_equal record, util_memcache(record)
  end

  def test_class_find_complex_without_memcache
    CachedModel.use_local_cache = true
    CachedModel.use_memcache = false

    record = Concrete.find(1, :order => 'lock_version')

    assert_equal @model.id + 1, record.id

    assert_equal record, util_local(record)
    assert_equal nil, util_memcache(record)
  end

  def test_class_find_in_local_cache
    CachedModel.use_local_cache = true
    util_set

    record = Concrete.find(1, :order => 'lock_version')
    assert_equal @model.id + 1, record.id

    assert_equal record, util_local(record)
  end

  def test_class_find_in_memcache
    CachedModel.use_local_cache = true
    CachedModel.use_memcache = true
    util_set
    CachedModel.cache_reset

    record = Concrete.find @model.id

    assert_equal @model, record

    assert_equal record, util_local(record)
  end

  def test_class_find_multiple
    CachedModel.use_local_cache = true
    ids = [@model.id + 1, @model.id + 2, @model.id + 3]
    records = Concrete.find(*ids)
    assert_equal ids, records.map { |r| r.id }

    assert_equal ids.map { |i| "#{@model.class}:#{i}" }.sort,
                 CachedModel.cache_local.keys.sort
    assert_equal ids.map { |i| "active_record:#{@model.class}:#{i}" }.sort,
                 Cache.cache.keys.sort
  end

  def test_class_find_not_cached
    CachedModel.use_local_cache = true
    record = Concrete.find @model.id + 1
    assert_equal @model.id + 1, record.id

    assert_equal record, util_local(record)
    assert_equal record, util_memcache(record)
  end

  def test_class_find_by_sql
    CachedModel.use_local_cache = true
    q = "SELECT * FROM concrete WHERE (concrete.id = #{@model.id + 1}) LIMIT 1"
    record = Concrete.find_by_sql(q).first
    assert_equal @model.id + 1, record.id

    assert_equal record, util_local(record)
    assert_equal record, util_memcache(record)
  end

  def test_class_find_by_sql_extra_space
    CachedModel.use_local_cache = true
    q = "SELECT * FROM concrete WHERE (concrete.id = #{@model.id + 1})  LIMIT 1"
    record = Concrete.find_by_sql(q).first
    assert_equal @model.id + 1, record.id

    assert_equal record, util_local(record)
    assert_equal record, util_memcache(record)
  end

  def test_class_find_by_sql_no_record
    q = "SELECT * FROM concrete WHERE (concrete.id = -1) LIMIT 1"

    records = Concrete.find_by_sql q

    assert_equal [], records
  end

  def test_class_ttl
    assert_equal 900, CachedModel.ttl
    CachedModel.ttl = 800
    assert_equal 800, CachedModel.ttl
  end

  def test_class_use_local_cache_eh
    CachedModel.use_local_cache = true
    assert_equal true, CachedModel.use_local_cache?
    CachedModel.use_local_cache = false
    assert_equal false, CachedModel.use_local_cache?
  end

  def test_class_use_memcache_eh
    CachedModel.use_memcache = true
    assert_equal true, CachedModel.use_memcache?
    CachedModel.use_memcache = false
    assert_equal false, CachedModel.use_memcache?
  end

  def test_cache_delete
    CachedModel.use_local_cache = true
    util_set

    @model.cache_delete

    assert_empty CachedModel.cache_local
    assert_empty Cache.cache
  end

  def test_cache_key_local
    assert_equal "#{@model.class}:#{@model.id}", @model.cache_key_local
  end

  def test_cache_key_memcache
    assert_equal "active_record:#{@model.class}:#{@model.id}",
                 @model.cache_key_memcache
  end

  def test_cache_local
    assert_same CachedModel.cache_local, @model.cache_local
  end

  def test_cache_store
    CachedModel.use_local_cache = true
    CachedModel.use_memcache = true

    @model.cache_store

    deny_empty CachedModel.cache_local
    deny_empty Cache.cache

    assert_equal @model, util_local(@model)
    assert_equal @model, util_memcache(@model)
    assert_equal CachedModel.ttl, Cache.ttl[@model.cache_key_memcache]
  end

  def test_cache_store_in_transaction
    CachedModel.use_local_cache = true
    CachedModel.use_memcache = true
    CachedModel.cache_delay_commit[0] = []

    @model.cache_store

    deny_empty CachedModel.cache_delay_commit
    assert_empty CachedModel.cache_local
    assert_empty Cache.cache
  end

  def test_cache_store_without_local_cache
    CachedModel.use_local_cache = false
    CachedModel.use_memcache = true

    @model.cache_store

    assert_empty CachedModel.cache_local
    deny_empty Cache.cache

    assert_equal nil, util_local(@model)
    assert_equal @model, util_memcache(@model)
    assert_equal CachedModel.ttl, Cache.ttl[@model.cache_key_memcache]
  end

  def test_cache_store_without_memcache
    CachedModel.use_local_cache = true
    CachedModel.use_memcache = false

    @model.cache_store

    deny_empty CachedModel.cache_local
    assert_empty Cache.cache

    assert_equal @model, util_local(@model)
    assert_equal nil, util_memcache(@model)
  end

  def test_cache_store_with_attributes
    CachedModel.use_local_cache = true
    @model.attributes[:extra] = 'extra'
    @model.cache_store

    deny_empty CachedModel.cache_local
    deny_empty Cache.cache

    local_model = util_local(@model)
    mem_model = util_memcache(@model)
    assert_equal @model, local_model
    assert_equal @model, mem_model
    assert_equal CachedModel.ttl, Cache.ttl[@model.cache_key_memcache]

    expected = {:data => 'data'}

    assert_equal expected, local_model.attributes
    assert_equal expected, mem_model.attributes
  end

  def test_destroy
    CachedModel.use_local_cache = true
    util_set

    @model.destroy

    assert_empty CachedModel.cache_local
    assert_empty Cache.cache
  end

  def test_reload
    util_set

    @model.reload

    deny_empty CachedModel.cache_local
    deny_empty Cache.cache

    assert_equal 'datb',
                 util_local(@model).attributes[:data]
    assert_equal 'datb',
                 util_memcache(@model).attributes[:data]
  end

  def test_transaction_fail
    CachedModel.use_local_cache = true

    e = assert_raise RuntimeError do
      @model.transaction do
        @model.attributes[:data] = 'atad'
        @model.save
        raise 'Oh nos!'
      end
    end

    assert_equal 'Oh nos!', e.message
    assert_equal nil, util_local(@model)
    assert_equal nil, util_memcache(@model)
  end

  def test_transaction_nested
    CachedModel.use_local_cache = true

    @model.transaction do
      @model.transaction do
        @model.attributes[:data] = 'value1'
        @model.save

        assert_equal nil, util_local(@model), 'in t1 local'
        assert_equal nil, util_memcache(@model), 'in t1 memcache'
      end

      assert_equal 'value1', util_local(@model).attributes[:data],
                   'completed t1 local'
      assert_equal 'value1', util_memcache(@model).attributes[:data],
                   'completed t1 memcache'

      @model.attributes[:data] = 'value2'
      @model.save

      assert_equal 'value1', util_local(@model).attributes[:data],
                   'in t2 local'
      assert_equal 'value1', util_memcache(@model).attributes[:data],
                   'in t2 memcache'
    end

    assert_equal 'value2', util_local(@model).attributes[:data],
                 'completed t2 local'
    assert_equal 'value2', util_memcache(@model).attributes[:data],
                 'completed t2 local'
  end

  def test_transaction_pass
    CachedModel.use_local_cache = true

    result = @model.transaction do
      @model.attributes[:data] = 'atad'
      @model.save

      assert_equal nil, util_local(@model)
      assert_equal nil, util_memcache(@model)

      :some_value
    end

    assert_equal :some_value, result

    assert_equal 'atad', util_local(@model).attributes[:data]
    assert_equal 'atad',
                 util_memcache(@model).attributes[:data]

  end

  def test_update
    util_set

    @model.attributes[:data] = 'atad'
    assert_equal true, @model.update, "Updates should return true"

    deny_empty CachedModel.cache_local
    deny_empty Cache.cache

    assert_equal 'atad',
                 util_local(@model).attributes[:data]
    assert_equal 'atad',
                 util_memcache(@model).attributes[:data]
  end

  def util_local(model)
    CachedModel.cache_local[model.cache_key_local]
  end

  def util_memcache(model)
    Cache.cache[model.cache_key_memcache]
  end

  def util_set(klass = @model.class, id = @model.id, data = @model)
    key = "#{klass}:#{id}"
    CachedModel.cache_local[key] = data
    Cache.cache["active_record:#{key}"] = data
  end

end

