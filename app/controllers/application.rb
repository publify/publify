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
  
  def auto_discovery_defaults
    auto_discovery_feed(:type => 'feed')
  end
  
  def auto_discovery_feed(options)
    options = {:only_path => false, :action => 'feed', :controller => 'xml'}.merge options
    @auto_discovery_url_rss = url_for(({:format => 'rss'}.merge options))
    @auto_discovery_url_atom = url_for(({:format => 'atom'}.merge options))
  end
  
  def article_url(article, only_path = true, anchor = nil)
    url_for :only_path => only_path, :controller=>"/articles", :action =>"permalink", :year => article.created_at.year, :month => sprintf("%.2d", article.created_at.month), :day => sprintf("%.2d", article.created_at.day), :title => article.permalink, :anchor => anchor
  end
  
  def cache
    $cache ||= SimpleCache.new 1.hour
  end
  
  def reload_settings
    config.reload
  end

  def theme_layout
    Theme.current.layout
  end
  
  def filter_text(text, filters, filterparams={}, filter_html=false)
    map=TextFilter.filters_map

    if(filter_html)
      filters = [:htmlfilter, filters].flatten
    end

    filters.each do |filter|
      begin
        filter_component = map[filter.to_s].controller_path
        text = render_component_as_string(:controller => filter_component, 
          :action => 'filtertext', 
          :params => {:text => text, :filterparams => filterparams} )
      rescue => err
        logger.error "Filter #{filter} failed: #{err}"
      end
    end

    text
  end

  def filter_text_by_name(text, filtername, filter_html=false)
    f = TextFilter.find_by_name(filtername)
    if (f)
      filters = [:macropre, f.markup, :macropost, f.filters].flatten
      filter_text(text,filters,f.params,filter_html)
    else
      filter_text(text,[:macropre,:macropost],{},filter_html)
    end
  end
end

require_dependency 'controllers/textfilter_controller'