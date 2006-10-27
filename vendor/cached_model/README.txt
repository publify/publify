= CachedModel

Rubyforge Project:

http://rubyforge.org/projects/rctools/

Documentation:

http://dev.robotcoop.com/Libraries/cached_model/

== About

CachedModel stores Rails ActiveRecord objects in memcache allowing for very
fast retrievals.  CachedModel uses the ActiveRecord::Locking to ensure that
you don't perform multiple updates.

== CachedModel Doesn't...

CachedModel is not magic.

CachedModel only accelerates simple finds for single rows.

CachedModel won't cache every query you run.

CachedModel isn't smart enough to determine the dependencies between your
queries so that it can accelerate more complicated queries.  Without these
smarts you'll only end up with a broken application.

If you want to cache more complicated queries you need do it by hand.

== Using CachedModel

First, install the cached_model gem:

  $ sudo gem install cached_model

Then set up memcache-client for CachedModel by setting CACHE in your
config/environment files:

  CACHE = MemCache.new 'localhost:11211', :namespace => 'my_rails_app'

You will need separate namespaces for production and development, if
you are using memcache on the same machine.

Note that using memcache with tests will cause test failures, so set your
memcache to be readonly for the test environment.

Then make Rails load the gem:

  $ tail -n 4 config/environment.rb 
  # Include your application configuration below
  
  require 'cached_model'

Then edit your ActiveRecord model to inherit from CachedModel instead of
ActiveRecord::Base:

  $ head -n 8 app/models/photo.rb
  ##
  # A Photo from Flickr.
  
  class Photo < CachedModel
  
    belongs_to :point
    belongs_to :route

== Extra Features

=== Local Cache

CachedModel also incorporates an in-process cache, but it is disabled by
default.  In order to enable the in-process cache enable it in your
environment.rb:

  CachedModel.use_local_cache = true

And add a after_filter that flushes the local cache:

  class ApplicationController < ActionController::Base
  
    after_filter { CachedModel.cache_reset }
  
  end

IF YOU DO NOT ADD THE AFTER FILTER YOU WILL EXPERIENCE EXTREME PROCESS GROWTH.

=== Memcache

Memcache may be disabled and the TTL for objects stored in memcache may be
changed:

  CachedModel.use_memcache = false
  CachedModel.ttl = 86400

The default TTL for memcache objects is 900 seconds.

