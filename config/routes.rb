ActionController::Routing::Routes.draw do |map|

  # default
  map.root :controller  => 'articles', :action => 'index'

  # TODO: use only in archive sidebar. See how made other system
  map.articles_by_month ':year/:month', :controller => 'articles', :action => 'index', :year => /\d{4}/, :month => /\d{1,2}/
  map.articles_by_month_page ':year/:month/page/:page', :controller => 'articles', :action => 'index', :year => /\d{4}/, :month => /\d{1,2}/
  map.articles_by_year ':year', :controller => 'articles', :action => 'index', :year => /\d{4}/
  map.articles_by_year_page ':year/page/:page', :controller => 'articles', :action => 'index', :year => /\d{4}/

  map.admin 'admin', :controller  => 'admin/dashboard', :action => 'index'

  # make rss feed urls pretty and let them end in .xml
  # this improves caches_page because now apache and webrick will send out the
  # cached feeds with the correct xml mime type.

  map.xml 'articles.:format', :controller => 'articles', :action => 'index', :format => /rss|atom/
  
  map.with_options :controller => 'xml', :path_prefix => 'xml' do |controller|
    controller.xml 'itunes/feed.xml', :action => 'itunes'
    controller.xml 'articlerss/:id/feed.xml', :action => 'articlerss'
    controller.xml 'commentrss/feed.xml', :action => 'commentrss'
    controller.xml 'trackbackrss/feed.xml', :action => 'trackbackrss'
    
    controller.with_options :action => 'feed' do |action|
      action.xml 'rss', :type => 'feed', :format => 'rss'
      action.xml 'sitemap.xml', :format => 'googlesitemap', :type => 'sitemap', :path_prefix => nil
      action.xml ':format/feed.xml', :type => 'feed'
      action.xml ':format/:type/feed.xml'
      action.xml ':format/:type/:id/feed.xml'
    end
  end
  

  map.resources :comments, :name_prefix => 'admin_', :collection => [:preview]
  map.resources :trackbacks

  map.live_search_articles '/live_search/', :controller => "articles", :action => "live_search"
  map.connect '/search/:q.:format', :controller => "articles", :action => "search"
  map.connect '/search/', :controller => "articles", :action => "search"
  map.connect '/archives/', :controller => "articles", :action => "archives"

  # I thinks it's useless. More investigating
  map.connect "trackbacks/:id/:day/:month/:year",
    :controller => 'trackbacks', :action => 'create', :conditions => {:method => :post}

  # Before use inflected_resource
  map.resources :categories, :except => [:show, :update, :destroy, :edit]
  map.resources :categories, :as => 'category', :only => [:show, :edit, :update, :destroy]

  map.connect '/category/:id/page/:page', :controller => 'categories', :action => 'show'
  
  # Before use inflected_resource
  map.resources :tags, :except => [:show, :update, :destroy, :edit]
  map.resources :tags, :as => 'tag', :only => [:show, :edit, :update, :destroy]

  map.connect '/tag/:id/page/:page', :controller => 'tags', :action => 'show'
  map.connect '/tags/page/:page', :controller => 'tags', :action => 'index'
  
  # allow neat perma urls
  map.connect 'page/:page',
    :controller => 'articles', :action => 'index',
    :page => /\d+/

  date_options = { :year => /\d{4}/, :month => /(?:0?[1-9]|1[012])/, :day => /(?:0[1-9]|[12]\d|3[01])/ }

  map.with_options(:conditions => {:method => :get}) do |get|
    get.connect 'pages/*name',:controller => 'articles', :action => 'view_page'

    get.with_options(:controller => 'theme', :filename => /.*/, :conditions => {:method => :get}) do |theme|
      theme.connect 'stylesheets/theme/:filename', :action => 'stylesheets'
      theme.connect 'javascripts/theme/:filename', :action => 'javascript'
      theme.connect 'images/theme/:filename',      :action => 'images'
    end

    # For the tests
    get.connect 'theme/static_view_test', :controller => 'theme', :action => 'static_view_test'

    map.connect 'plugins/filters/:filter/:public_action',
      :controller => 'textfilter', :action => 'public_action'
  end

  # Work around the Bad URI bug
  %w{ accounts backend files sidebar textfilter xml }.each do |i|
    map.connect "#{i}", :controller => "#{i}", :action => 'index'
    map.connect "#{i}/:action", :controller => "#{i}"
    map.connect "#{i}/:action/:id", :controller => i, :id => nil
  end

  %w{advanced blacklist cache categories comments content feedback general pages
     resources sidebar textfilters themes trackbacks users settings tags }.each do |i|
    map.connect "/admin/#{i}", :controller => "admin/#{i}", :action => 'index'
    map.connect "/admin/#{i}/:action/:id", :controller => "admin/#{i}", :action => nil, :id => nil
  end

  map.connect '*from', :controller => 'redirect', :action => 'redirect'

  map.connect(':controller/:action/:id') do |default_route|
    class << default_route
      def recognize_with_deprecation(path, environment = {})
        RAILS_DEFAULT_LOGGER.info "#{path} hit the default_route buffer"
        recognize_without_deprecation(path, environment)
      end
      alias_method_chain :recognize, :deprecation

      def generate_with_deprecation(options, hash, expire_on = {})
        RAILS_DEFAULT_LOGGER.info "generate(#{options.inspect}, #{hash.inspect}, #{expire_on.inspect}) reached the default route"
        #         if RAILS_ENV == 'test'
        #           raise "Don't rely on default route generation"
        #         end
        generate_without_deprecation(options, hash, expire_on)
      end
      alias_method_chain :generate, :deprecation
    end
  end
end
