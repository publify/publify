class RouteCache
  @cache = {}

  def self.clear
    @cache = {}
  end

  def self.[](key)
    @cache[key.inspect]
  end

  def self.[]=(key,value)
    @cache[key.inspect]=value
  end
end