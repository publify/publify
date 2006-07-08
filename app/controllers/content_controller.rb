# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ContentController < ApplicationController
  class ExpiryFilter
    def before(controller)
      @request_time = Time.now
    end

    def after(controller)
       future_article =
         Article.find(:first,
                      :conditions => ['published = ? AND published_at > ?', true, @request_time],
                      :order =>  "published_at ASC" )
       if future_article
         delta = future_article.published_at - Time.now
         controller.response.lifetime = (delta <= 0) ? 0 : delta
       end
    end
  end

  include LoginSystem
  model :user
  helper :theme
  before_filter :auto_discovery_defaults

  def self.caches_action_with_params(*actions)
    super
    around_filter ExpiryFilter.new, :only => actions
  end

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
    # Special cased ugliness. Get rid of it when there's a user feed.
    if options[:type] == 'user'
      options[:type] = 'feed'
      options[:id] = nil
    end

    @auto_discovery_url_rss = url_for(({:format => 'rss20'}.merge options))
    @auto_discovery_url_atom = url_for(({:format => 'atom'}.merge options))
  end

  def theme_layout
    this_blog.current_theme.layout
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

  include_protected ActionView::Helpers::TagHelper, ActionView::Helpers::TextHelper

end
