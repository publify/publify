module MetaFragmentCache
  def meta_fragment_key(name)
    return "META/META/#{name}", "META/DATA/#{name}"
  end
  
  def read_meta_fragment(name, options = nil)
    metakey, contentkey = meta_fragment_key(name)
    meta = YAML.load(read_fragment(metakey)) rescue {}
    content = read_fragment(contentkey)
    return meta, content
  end
  
  def read_meta_fragment_expire(name, options = nil)
    meta, content = read_meta_fragment(name, options)
    if(meta.kind_of? Hash and meta[:expires].kind_of? Time and meta[:expires] < Time.now)
      expire_meta_fragment(name)
      return {},nil
    else
      return meta, content
    end
  end
  
  def write_meta_fragment(name, meta, content, options = nil)
    metakey, contentkey = meta_fragment_key(name)
    write_fragment(contentkey, content)
    write_fragment(metakey, YAML.dump(meta))
  end
  
  def expire_meta_fragment(name, options = nil)
    if(name.kind_of? Regexp)
      metakey, contentkey = meta_fragment_key('.*'+name.source).collect {|key| Regexp.new("^#{key}")}
    elsif(name.kind_of? String)
      metakey, contentkey = meta_fragment_key(name)
    else
      raise "MetaFragmentCache only supports regexes and strings as expire keys"
    end
    expire_fragment(metakey)
    expire_fragment(contentkey)
  end
end

module ActionController
  class Base
    include MetaFragmentCache
  end
end
