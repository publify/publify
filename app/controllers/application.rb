# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base
  include LoginSystem
  model :user
  
  before_filter :reload_settings
  before_filter :auto_discovery_defaults
  
  def self.cache_page(content, path)
    begin
      # Don't cache the page if there are any questionmark characters in the url
      unless path =~ /\?\w+/ or path =~ /page\d+$/
        super(content,path)
        PageCache.create(:name => page_cache_file(path))
      end
    rescue # if there's a caching error, then just return the content.
      content
    end
  end

  def self.expire_page(path)
    if cache = PageCache.find(:first, :conditions => ['name = ?', path])
      cache.destroy
    end
  end
  
  def reload_settings
    unless @request.instance_variable_get(:@config_reloaded)
      @request.instance_variable_set(:@config_reloaded, true)
      config.reload
    end
  end

  def auto_discovery_defaults
    @auto_discovery_url_rss = 
        @request.instance_variable_get(:@auto_discovery_url_rss)
    @auto_discovery_url_atom =
         @request.instance_variable_get(:@auto_discovery_url_atom)
    unless @auto_discovery_url_rss && @auto_discovery_url_atom
      auto_discovery_feed(:type => 'feed')
      @request.instance_variable_set(:@auto_discovery_url_rss,
                                      @auto_discovery_url_rss)
      @request.instance_variable_set(:@auto_discovery_url_atom, 
                                      @auto_discovery_url_atom)
    end
  end
    
  def auto_discovery_feed(options)
    options = {:only_path => false, :action => 'feed', :controller => 'xml'}.merge options
    @auto_discovery_url_rss = url_for(({:format => 'rss20'}.merge options))
    @auto_discovery_url_atom = url_for(({:format => 'atom10'}.merge options))
  end
  
  def article_url(article, only_path = true, anchor = nil)
    url_for :only_path => only_path, :controller=>"/articles", :action =>"permalink", :year => article.created_at.year, :month => sprintf("%.2d", article.created_at.month), :day => sprintf("%.2d", article.created_at.day), :title => article.permalink, :anchor => anchor
  end

  def server_url
    url_for :only_path => false, :controller => "/"
  end
  
  def cache
    $cache ||= SimpleCache.new 1.hour
  end
  
  def theme_layout
    Theme.current.layout
  end
  
  helper_method :contents
  def contents
    if @articles
      @articles
    elsif @article
      [@article]
    elsif @page
      [@page]
    else
      []
    end
  end
  
  protected

  def self.include_protected(*modules)
    modules.reverse.each do |mod|
      included_methods = mod.public_instance_methods.reject do |meth|
        self.method_defined?(meth)
      end
      self.send(:include, mod)
      included_methods.each do |meth|
        protected meth
      end
    end
  end
  
  include_protected ActionView::Helpers::TagHelper, ActionView::Helpers::TextHelper
  
end

require_dependency 'controllers/textfilter_controller'
