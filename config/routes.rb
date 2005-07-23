ActionController::Routing::Routes.draw do |map|

  # default   
  map.index '', :controller  => 'articles', :action => 'index'
  map.admin 'admin', :controller  => 'admin/general', :action => 'index'
  
  # admin/comments controller needs parent article id
  map.connect 'admin/comments/article/:article_id/:action/:id',
    :controller => 'admin/comments', :action => nil, :id => nil
  map.connect 'admin/trackback/article/:article_id/:action/:id',
    :controller => 'admin/trackback', :action => nil, :id => nil

  # make rss feed urls pretty and let them end in .xml
  # this improves caches_page because now apache and webrick will send out the 
  # cached feeds with the correct xml mime type. 
  map.xml 'xml/:action/feed.xml', :controller => 'xml'
  map.xml 'xml/articlerss/:id/feed.xml', :controller => 'xml', :action => 'articlerss'

  # allow neat perma urls
  map.connect 'articles/:page',
    :controller => 'articles', :action => 'index', :page => nil,
    :requirements => { :page => /page\d+/ }
  map.connect 'articles/:year/:page',
    :controller => 'articles', :action => 'find_by_date', :page => nil,
    :requirements => { :page => /page\d+/, :year => /\d{4}/ }
  map.connect 'articles/:year/:month/:page',
    :controller => 'articles', :action => 'find_by_date', :page => nil,
    :requirements => { :page => /page\d+/, :year => /\d{4}/, :month => /\d{1,2}/ }
  map.connect 'articles/:year/:month/:day/:page',
    :controller => 'articles', :action => 'find_by_date', :page => nil,
    :requirements => { :page => /page\d+/, :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ }
  map.connect 'articles/:year/:month/:day/:title',
    :controller => 'articles', :action => 'permalink',
    :requirements => { :year => /\d{4}/, :day => /\d{1,2}/, :month => /\d{1,2}/ }
      
  # Allow legacy urls to still work
  map.connect ':controller/:action/:id/:page', :page => nil,
    :requirements => { :page => /page\d+/ }
  
end
