require 'singleton'
class UrlPolicy
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
    with_options(:only_path => true) do |o|
      case args.first
      when nil
        raise ArgumentError, "Argument cannot be nil"
      when ActiveRecord::Base
        o.url_for_object(*args)
      else
        o.url_for_without_policy(*args)
      end
    end
  end

  alias_method_chain :url_for, :policy

  def url_for_object(object, opts = {})
    with_options(opts) { |o|
      o.url_for(object.to_params(self))
    }
  end

  def edit_url_for(object, opts = {})
    with_options(opts) { |o|
      url_for(object.to_params(self).merge(:action => object.new_record? ? :new : :edit))
    }
  end

  def article_params(article)
    returning(:controller => 'articles') do |params|
      if article.new_record?
        params.merge!(:action => :new)
      else
        date = article.published_at
        params.merge!(:action => :show,
                     :year   => date.year,
                     :month  => '%02i' % date.month,
                     :day    => '%02i' % date.day,
                     :id     => article.permalink)
      end
    end
  end

  def feedback_params(feedback)
    returning(:controller => feedback.class.name.pluralize.underscore, :action => 'show') do |params|
      article_params(feedback.article).each do |k,v|
        next if k == :controller || k == :action
        params["article_#{k}".to_sym] = v
      end
      params[:id] = feedback.to_param
    end
  end
end
