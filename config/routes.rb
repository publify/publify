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
  map.xml 'xml/articlerss/:id/feed.xml', :controller => 'xml', :action => 'articlerss'
  map.xml 'xml/commentrss/feed.xml', :controller => 'xml', :action => 'commentrss'
  map.xml 'xml/trackbackrss/feed.xml', :controller => 'xml', :action => 'trackbackrss'
  
  map.xml 'xml/:format/feed.xml', :controller => 'xml', :action => 'feed', :type => 'feed'
  map.xml 'xml/:format/:type/feed.xml', :controller => 'xml', :action => 'feed'
  map.xml 'xml/:format/:type/:id/feed.xml', :controller => 'xml', :action => 'feed'
  map.xml 'xml/rss', :controller => 'xml', :action => 'feed', :type => 'feed'
  
  # allow neat perma urls
  map.connect 'articles',
    :controller => 'articles', :action => 'index'
  map.connect 'articles/page/:page',
    :controller => 'articles', :action => 'index',
    :page => /\d+/

  map.connect 'articles/:year/:month/:day',
    :controller => 'articles', :action => 'find_by_date',
    :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/
  map.connect 'articles/:year/:month',
    :controller => 'articles', :action => 'find_by_date',
    :year => /\d{4}/, :month => /\d{1,2}/
  map.connect 'articles/:year',
    :controller => 'articles', :action => 'find_by_date',
    :year => /\d{4}/

  map.connect 'articles/:year/:month/:day/page/:page',
    :controller => 'articles', :action => 'find_by_date',
    :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/, :page => /\d+/
  map.connect 'articles/:year/:month/page/:page',
    :controller => 'articles', :action => 'find_by_date',
    :year => /\d{4}/, :month => /\d{1,2}/, :page => /\d+/
  map.connect 'articles/:year/page/:page',
    :controller => 'articles', :action => 'find_by_date',
    :year => /\d{4}/, :page => /\d+/

  map.connect 'articles/:year/:month/:day/:title',
    :controller => 'articles', :action => 'permalink',
    :year => /\d{4}/, :day => /\d{1,2}/, :month => /\d{1,2}/

  map.connect 'articles/category/:id',
    :controller => 'articles', :action => 'category'
  map.connect 'articles/category/:id/page/:page',
    :controller => 'articles', :action => 'category',
    :page => /\d+/

  map.connect 'articles/tag/:id',
    :controller => 'articles', :action => 'tag'
  map.connect 'articles/tag/:id/page/:page',
    :controller => 'articles', :action => 'tag',
    :page => /\d+/

  map.connect 'pages/*name',:controller => 'articles', :action => 'view_page'

  map.connect 'stylesheets/theme/:filename',
    :controller => 'theme', :action => 'stylesheets'
  map.connect 'javascript/theme/:filename',
    :controller => 'theme', :action => 'javascript'
  map.connect 'images/theme/:filename',
    :controller => 'theme', :action => 'images'

  map.connect 'plugins/filters/:filter/:public_action',
    :controller => 'textfilter', :action => 'public_action'

  # Kill attempts to connect directly to the theme controller.
  # Ideally we'd disable these by removing the default route (below),
  # but that breaks too many things for Typo 2.5.
  map.connect 'theme/*stuff',
    :controller => 'theme', :action => 'error'
     
  # Allow legacy urls to still work
  map.connect ':controller/:action/:id'
end
