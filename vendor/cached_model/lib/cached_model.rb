$TESTING_CM = defined? $TESTING_CM

require 'timeout'
require 'memcache_util' unless $TESTING_CM

##
# An abstract ActiveRecord descendant that caches records in memcache and in
# local memory.
#
# CachedModel can store into both a local in-memory cache and in memcached.
# By default memcached is enabled and the local cache is disabled.
#
# Local cache use can be enabled or disabled with
# CachedModel::use_local_cache=.  If you do enable the local cache be sure to
# add a before filter that calls CachedModel::cache_reset for every request.
#
# memcached use can be enabled or disabled with CachedModel::use_memcache=.
#
# You can adjust the memcached TTL with CachedModel::ttl=

class CachedModel < ActiveRecord::Base

  @cache_delay_commit = {}
  @cache_local = {}
  @cache_transaction_level = 0
  @use_local_cache = false
  @use_memcache = true
  @ttl = 60 * 15

  class << self

    # :stopdoc:

    ##
    # The transaction commit buffer.  You shouldn't touch me.

    attr_accessor :cache_delay_commit

    ##
    # The local process cache.  You shouldn't touch me.

    attr_reader :cache_local

    ##
    # The transaction nesting level.  You shouldn't touch me.

    attr_accessor :cache_transaction_level

    # :startdoc:

    ##
    # Enables or disables use of the local cache.
    #
    # NOTE if you enable this you must call #cache_reset or you will
    # experience uncontrollable process growth!
    #
    # Defaults to false.

    attr_writer :use_local_cache

    ##
    # Enables or disables the use of memcache.

    attr_writer :use_memcache

    ##
    # Memcache record time-to-live for stored records.

    attr_accessor :ttl

  end

  ##
  # We only work on 1.1.2 + because Rails broke backwards compatibility
  # despite a bug http://dev.rubyonrails.org/ticket/3704

  if Rails::VERSION::MAJOR > 1 or
     (Rails::VERSION::MAJOR == 1 and Rails::VERSION::MINOR > 1) or
     (Rails::VERSION::MAJOR == 1 and Rails::VERSION::MINOR == 1 and
      Rails::VERSION::TINY >= 2) then

    ##
    # Override the flawed assumption ActiveRecord::Base makes about
    # inheritance.

    self.abstract_class = true
  else
    raise NotImplementedError, 'upgrade to Rails 1.1.2+'
  end

  ##
  # Invalidate the cache entry for a record.  The update method will
  # automatically invalidate the cache when updates are made through
  # ActiveRecord model record.  However, several methods update tables with
  # direct sql queries for effeciency.  These methods should call this method
  # to invalidate the cache after making those changes.
  #
  # NOTE - if a SQL query updates multiple rows with one query, there is
  # currently no way to invalidate the affected entries unless the entire
  # cache is dumped or until the TTL expires, so try not to do this.

  def self.cache_delete(klass, id)
    key = "#{klass}:#{id}"
    CachedModel.cache_local.delete key if CachedModel.use_local_cache?
    Cache.delete "active_record:#{key}" if CachedModel.use_memcache?
  end

  ##
  # Invalidate the local process cache.  This should be called from a before
  # filter at the beginning of each request.

  def self.cache_reset
    CachedModel.cache_local.clear if CachedModel.use_local_cache?
  end

  ##
  # Override the find method to look for values in the cache before going to
  # the database.
  #--
  # TODO Push a bunch of code down into find_by_sql where it really should
  # belong.

  def self.find(*args)
    args[0] = args.first.to_i if args.first =~ /\A\d+\Z/
    # Only handle simple find requests.  If the request was more complicated,
    # let the base class handle it, but store the retrieved records in the
    # local cache in case we need them later.
    if args.length != 1 or not Fixnum === args.first then
      # Rails requires multiple levels of indirection to look up a record
      # First call super
      records = super
      # Then, if it was a :all, just return
      return records if args.first == :all
      return records if RAILS_ENV == 'test'
      case records
      when Array then
        records.each { |r| r.cache_store }
      end
      return records
    end

    return super
  end

  ##
  # Find by primary key from the cache.

  def self.find_by_sql(*args)
    return super unless args.first =~ /^SELECT \* FROM #{table_name} WHERE \(#{table_name}\.#{primary_key} = '?(\d+)'?\) +LIMIT 1/

    id = $1.to_i

    # Try to find the record in the local cache.
    cache_key_local = "#{name}:#{id}"
    if CachedModel.use_local_cache? then
      record = CachedModel.cache_local[cache_key_local]
      return [record] unless record.nil?
    end

    # Try to find the record in memcache and add it to the local cache
    if CachedModel.use_memcache? then
      record = Cache.get "active_record:#{cache_key_local}"
      unless record.nil? then
        if CachedModel.use_local_cache? then
          CachedModel.cache_local[cache_key_local] = record
        end
        return [record]
      end
    end

    # Fetch the record from the DB
    records = super
    records.first.cache_store unless records.empty? # only one
    return records
  end

  ##
  # Delay updating the cache while in a transaction.

  def self.transaction(*args)
    level = CachedModel.cache_transaction_level += 1
    CachedModel.cache_delay_commit[level] = []

    value = super

    waiting = CachedModel.cache_delay_commit.delete level
    waiting.each do |obj| obj.cache_store end

    return value
  ensure
    CachedModel.cache_transaction_level -= 1
  end

  ##
  # Returns true if use of the local cache is enabled.

  def self.use_local_cache?
    return @use_local_cache
  end

  ##
  # Returns true if use of memcache is enabled.

  def self.use_memcache?
    return @use_memcache
  end

  ##
  # Delete the entry from the cache now that it isn't in the DB.

  def destroy
    return super
  ensure
    cache_delete
  end

  ##
  # Invalidate the cache for this record before reloading from the DB.

  def reload
    cache_delete
    return super
  ensure
    cache_store
  end

  ##
  # Store a new copy of ourselves into the cache.

  def update
    return super
  ensure
    cache_store
  end

  ##
  # Remove this record from the cache.

  def cache_delete
    cache_local.delete cache_key_local if CachedModel.use_local_cache?
    Cache.delete cache_key_memcache if CachedModel.use_memcache?
  end

  ##
  # The local cache key for this record.

  def cache_key_local
    return "#{self.class}:#{id}"
  end

  ##
  # The memcache key for this record.

  def cache_key_memcache
    return "active_record:#{cache_key_local}"
  end

  ##
  # The local object cache.

  def cache_local
    return CachedModel.cache_local
  end

  ##
  # Store this record in the cache without associations.  Storing associations
  # leads to wasted cache space and hard-to-debug problems.

  def cache_store
    logger.info "Storing #{self} in the cache"
    obj = dup
    obj.send :instance_variable_set, :@attributes, attributes_before_type_cast
    if CachedModel.cache_delay_commit[CachedModel.cache_transaction_level].nil? then
      if CachedModel.use_local_cache? then
        cache_local[cache_key_local] = obj
      end
      if CachedModel.use_memcache? then
        Cache.put cache_key_memcache, obj, CachedModel.ttl
      end
    else
      CachedModel.cache_delay_commit[CachedModel.cache_transaction_level] << obj
    end
    nil
  end

end

