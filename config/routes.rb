ActionController::Routing::Routes.draw do |map|

  # default
  map.index '', :controller  => 'articles', :action => 'index'
  map.admin 'admin', :controller  => 'admin/general', :action => 'index'

  # admin/comments controller needs parent article id
  map.connect 'admin/comments/article/:article_id/:action/:id',
    :controller => 'admin/comments', :action => nil, :id => nil
  map.connect 'admin/trackbacks/article/:article_id/:action/:id',
    :controller => 'admin/trackbacks', :action => nil, :id => nil
  map.connect 'admin/content/:action/:id', :controller => 'admin/content'

  # make rss feed urls pretty and let them end in .xml
  # this improves caches_page because now apache and webrick will send out the
  # cached feeds with the correct xml mime type.
  map.xml 'xml/itunes/feed.xml', :controller => 'xml', :action => 'itunes'
  map.xml 'xml/articlerss/:id/feed.xml', :controller => 'xml', :action => 'articlerss'
  map.xml 'xml/commentrss/feed.xml', :controller => 'xml', :action => 'commentrss'
  map.xml 'xml/trackbackrss/feed.xml', :controller => 'xml', :action => 'trackbackrss'

  map.xml 'xml/:format/feed.xml', :controller => 'xml', :action => 'feed', :type => 'feed'
  map.xml 'xml/:format/:type/feed.xml', :controller => 'xml', :action => 'feed'
  map.xml 'xml/:format/:type/:id/feed.xml', :controller => 'xml', :action => 'feed'
  map.xml 'xml/rss', :controller => 'xml', :action => 'feed', :type => 'feed', :format => 'rss'
  map.xml 'sitemap.xml', :controller => 'xml', :action => 'feed', :format => 'googlesitemap', :type => 'sitemap'

  # allow neat perma urls
  map.connect 'articles',
    :controller => 'articles', :action => 'index'
  map.connect 'articles/page/:page',
    :controller => 'articles', :action => 'index',
    :page => /\d+/

  date_options = { :year => /\d{4}/, :month => /(?:0?[1-9]|1[12])/, :day => /(?:0[1-9]|[12]\d|3[01])/ }

  map.with_options(date_options) do |dated|
    dated.resources(:comments, :path_prefix => '/articles/:year/:month/:day/:title',
                    :members => { :preview => :get })
    dated.resources(:trackbacks, :path_prefix => '/articles/:year/:month/:day/:title')
  end

  map.with_options(:conditions => {:method => :get}) do |get|
    get.with_options(date_options.merge(:controller => 'articles')) do |dated|
      dated.with_options(:action => 'find_by_date') do |finder|
        finder.connect 'articles/:year/:month/:day',
          :defaults => {:year => nil, :month => nil, :day => nil}
        finder.connect 'articles/:year/page/:page',
          :month => nil, :day => nil, :page => /\d+/
        finder.connect 'articles/:year/:month/page/:page',
          :day => nil, :page => /\d+/
        finder.connect 'articles/:year/:month/:day/page/:page', :page => /\d+/
      end
      dated.article 'articles/:year/:month/:day/:title', :action => 'permalink'
    end

    %w(category tag).each do |value|
      get.with_options(:action => value, :controller => 'articles') do |m|
        m.connect "articles/#{value}/:id"
        m.connect "articles/#{value}/:id/page/:page", :page => /\d+/
      end
    end

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


  # Stats plugin
  map.connect '/stats/:action', :controller => 'sitealizer'

  # Work around the Bad URI bug
  %w{ accounts articles backend files live sidebar textfilter xml }.each do |i|
    map.connect "#{i}", :controller => "#{i}", :action => 'index'
    map.connect "#{i}/:action", :controller => "#{i}"
    map.connect "#{i}/:action/:id", :controller => i, :id => nil
  end

  %w{blacklist cache categories comments content feedback general pages
     resources sidebar textfilters themes trackbacks users}.each do |i|
    map.connect "/admin/#{i}", :controller => "admin/#{i}", :action => 'index'
    map.connect "/admin/#{i}/:action/:id", :controller => "admin/#{i}", :action => nil, :id => nil
  end

  returning(map.connect(':controller/:action/:id')) do |default_route|
    # Ick!
    default_route.write_generation

    class << default_route
      def recognize_with_deprecation(path, environment = {})
        RAILS_DEFAULT_LOGGER.info "#{path} hit the default_route buffer"
#         if RAILS_ENV=='test'
#           raise "Don't rely on default routes"
#         end
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
  map.connect '*from', :controller => 'redirect', :action => 'redirect'
end
