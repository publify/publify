ActionController::Routing::Routes.draw do |map|

  # default   
  map.connect '', :controller  => 'articles'

  # make rss feed urls pretty and let them end in .xml
  # this improves caches_page because now apache and webrick will send out the 
  # cached feeds with the correct xml mime type. 
  map.connect 'xml/:action/feed.xml', :controller  => 'xml'

  # allow neat perma urls
  map.connect 'articles/:year/:month/:day', :controller  => 'articles', :action => 'find_by_date', :year => /\d{4}/, :day => nil, :month => nil
  map.connect 'articles/:year/:month/:day/:title', :controller  => 'articles', :action => 'permalink', :year => /\d{4}/
      
  # Allow legacy urls to still work
  map.connect ':controller/:action/:id' #'
end
