##
# A utility wrapper around the MemCache client to simplify cache access.  All
# methods silently ignore MemCache errors.

module Cache

    ##
    # Returns the object at +key+ from the cache if successful, or nil if
    # either the object is not in the cache or if there was an error
    # attermpting to access the cache.
    #
    # If there is a cache miss and a block is given the result of the block
    # will be stored in the cache with optional +expiry+.

    def self.get(key, expiry = 0)
        start_time = Time.now
        result = CACHE.get key
        end_time = Time.now
        ActiveRecord::Base.logger.debug('MemCache Get (%0.6f)  %s' %
                                          [end_time - start_time, key])
        return result
    rescue MemCache::MemCacheError => err
        ActiveRecord::Base.logger.debug "MemCache Error: #{err.message}"
        if block_given? then
            value = yield
            put key, value, expiry
            return value
        else
            return nil
        end
    end

    ##
    # Places +value+ in the cache at +key+, with an optional +expiry+ time in
    # seconds.

    def self.put(key, value, expiry = 0)
        start_time = Time.now
        CACHE.set key, value, expiry
        end_time = Time.now
        ActiveRecord::Base.logger.debug('MemCache Set (%0.6f)  %s' %
                                          [end_time - start_time, key])
    rescue MemCache::MemCacheError => err
        ActiveRecord::Base.logger.debug "MemCache Error: #{err.message}"
    end

    ##
    # Deletes +key+ from the cache in +delay+ seconds. (?)

    def self.delete(key, delay = nil)
        start_time = Time.now
        CACHE.delete key, delay
        end_time = Time.now
        ActiveRecord::Base.logger.debug('MemCache Delete (%0.6f)  %s' %
                                          [end_time - start_time, key])
    rescue MemCache::MemCacheError => err
        ActiveRecord::Base.logger.debug "MemCache Error: #{err.message}"
    end

    ##
    # Resets all connections to mecache servers.

    def self.reset
        CACHE.reset
        ActiveRecord::Base.logger.debug 'MemCache Connections Reset'
    end
    
end

# vim: ts=4 sts=4 sw=4

