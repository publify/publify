require 'singleton'

# Helper method for hash
class Hash
  def prefix_keys(prefix)
    inject({}) {|o, (k,v)|
      returning(o) do
        if k.respond_to?(:to_str) || k.instance_of?(Symbol)
          o["#{prefix}_#{k}".to_sym] = v
        else
          o[k] = v
        end
      end
    }
  end

  def coalesce_params
    inject({}) { |o, (k, v)|
      returning(o) do
        if v.instance_of?(Hash)
          o.merge!(v.prefix_keys(k.to_s.singularize))
        else
          o[k] = v
        end
      end
    }
  end
end

class UrlPolicy
  class CollectionProxy
    attr_reader :parent
    def initialize(parent)
      @parent = parent
    end

    def new_record?
      false
    end

    def characteristic_hash
      {}
    end
  end

  include ::Singleton
  include ::ActionController::UrlWriter

  def self.default_url_options
    @default_url_options ||=
      begin
        uri = URI.parse(Blog.default.base_url)
        returning(:host => uri.host) do |opts|
          opts.merge(:port => uri.port) unless uri.port == 80
          opts.merge(:protocol => uri.scheme) unless uri.scheme == 'http'
        end
      end
  end

  def url_for_with_policy(*args)
    options = (Hash === args.last) ? args.pop.symbolize_keys : {}
    with_options(options.reverse_merge(:only_path => true)) do |o|
      case args.size
        when 0
        o.url_for_without_policy()
      when 2
        o.url_for_chain(*args)
      else
        if  association_collection? args.first
          return o.url_for_collection(*args)
        end

        case args.first
        when Class
          return o.url_for_class(*args)
        when ActiveRecord::Base, CollectionProxy
          return o.url_for_object(*args)
        else
          return o.url_for_without_policy(*args)
        end
      end
    end
  end

  alias_method_chain :url_for, :policy


  def url_for_class(klass, opts = {})
    url_for opts.reverse_merge(:controller => klass.name.pluralize.underscore)
  end

  def url_for_object(object, opts = {})
    suggested_params = params_for(object)
    if opts.has_key? :controller
      suggested_params.delete(:action)
    end

    url_for(suggested_params.merge(opts))
  end

  def association_collection?(object)
    object.respond_to?(:proxy_reflection) && object.respond_to?(:count)
  end

  def url_for_collection(collection, opts = {})
    owner = collection.proxy_owner;
    controller = collection.proxy_reflection.klass.name.pluralize.underscore
    url_for(CollectionProxy.new(owner),
            opts.merge(:controller => controller))
  end

  def url_for_chain(parent, klass, opts = { })
    url_for(CollectionProxy.new(parent),
            opts.merge(:controller => klass.name.pluralize.underscore))
  end

  def params_for(object)
    resource_params(object).coalesce_params.reverse_merge(default_controller_and_action_for(object))
  end

  def coalesce_params(params_hash)
    params_hash.coalesce_params
  end

  def default_controller_and_action_for(object)
    { :controller => object.class.name.pluralize.underscore,
      :action => object.new_record? ? :new : :show }
  end

  def edit_url_for(object, opts = {})
    with_options(opts) { |o|
      url_for(params_for(object).merge(:action => object.new_record? ? :new : :edit))
    }
  end

  def characteristic_hash(resource)
    raise ArgumentErrror, "#{resource}.new_record? must not be true" if resource.new_record?

    if resource.respond_to? :characteristic_hash
      return resource.characteristic_hash
    end

    class_specific_method_name = "characteristic_#{resource.class.name.underscore}_hash"
    if self.respond_to?(class_specific_method_name)
      self.send(class_specific_method_name, resource)
    else
      return { :id => resource.to_param }
    end
  end

  def characteristic_article_hash(article)
    date = article.published_at
    return { :year   => date.year,
      :month  => '%02i' % date.month,
      :day    => '%02i' % date.day,
      :id     => article.permalink }
  end

  def resource_params(resource)
    returning(ancestors_hash(resource)) do |params|
      unless resource.new_record?
        params.merge! characteristic_hash(resource)
      end
    end
  end

  alias_method :article_params, :resource_params
  alias_method :feedback_params, :resource_params

  def ancestors_hash(resource, collector = {})
    returning(collector) do |ret|
      if resource.respond_to?(:parent)
        collector[resource.parent.class.name.downcase.underscore] =
          characteristic_hash(resource.parent)
        ancestors_hash(resource.parent, collector)
      end
    end
  end
end
