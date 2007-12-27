class SimpleCache < Hash

  class Item
    attr_reader :expiry, :value
    def initialize(expiry, value)
      @expiry, @value = expiry, value
    end
  end

  def initialize(ttl)
    @ttl = ttl
    logger.info("  SimpleCache: will store items for #{ttl}s")
  end

  def [](key)
    item = super(key)
    if item.nil? or item.expiry <= Time.now
      logger.info("  SimpleCache: miss on #{key}")
      nil
    else
      logger.debug("  SimpleCache: hit on #{key}")
      item.value
    end
  end

  def []=(key, value)
    logger.info("  SimpleCache: store on #{key}")
    super(key, Item.new(@ttl.from_now, value))
    value
  end


  def logger
    @logger ||= RAILS_DEFAULT_LOGGER || Logger.new(STDOUT)
  end

end
