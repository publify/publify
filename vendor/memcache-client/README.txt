= memcache-client

Rubyforge Project:

http://rubyforge.org/projects/rctools/

== About

memcache-client is a fast memcached client.

== Installing memcache-client

Just install the gem:

  $ sudo gem install memcache-client

== Using memcache-client

With one server:

  CACHE = MemCache.new 'localhost:11211', :namespace => 'my_namespace'

Or with multiple servers:

  CACHE = MemCache.new %w[one.example.com:11211 two.example.com:11211],
                       :namespace => 'my_namespace'

See MemCache.new for details.

=== Using memcache-client with Rails

Rails will automatically load the memcache-client gem, but you may
need to uninstall Ruby-memcache, I don't know which one it will pick
by default.

Add your environment-specific caches to config/environment/*.  If you run both
development and production on the same machine be sure to use different
namespaces.  Be careful when running tests using memcache, you may get strange
results.  It will be less of a headache to simply use a readonly memcache when
testing.

memcache-client also comes with a wrapper called Cache in memcache_util.rb for
use with Rails.  To use it be sure to assign your memcache connection to
CACHE.  Cache returns nil on all memcache errors so you don't have to rescue
the errors yourself.  It has #get, #put and #delete module functions.

