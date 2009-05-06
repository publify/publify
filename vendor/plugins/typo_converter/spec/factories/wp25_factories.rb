# TODO: refactor this list (duplicated from wp25.rb)
require 'converters/wp25/option'
require 'converters/wp25/post'
require 'converters/wp25/comment'
require 'converters/wp25/term'
require 'converters/wp25/term_relationship'
require 'converters/wp25/term_taxonomy'
require 'converters/wp25/user'

# TODO: factory_girl can guess WP25::Option from 'WP25/option', but it tries
# to look up the class with const_get, which doesn't work for classes in modules.
Factory.define 'WP25/option', :class => WP25::Option do |c| end

Factory.define 'WP25/user', :class => WP25::User do |u|
  u.user_registered true
end

Factory.define 'WP25/post', :class => WP25::Post do |p|
  now = Time.now
  p.post_date now
  # TODO: figure out how to handle GMT conversion
  p.post_date_gmt {|p| p.post_date }
  p.post_modified {|p| p.post_date }
  p.post_modified_gmt {|p| p.post_modified }
  p.post_title 'Default Title'
  p.post_content 'This is default content.'
  p.post_excerpt ''
  p.to_ping '' # TODO: ?
  p.pinged '' # TODO: ?
  p.post_content_filtered {|p| p.post_content + ' [filtered]'} # TODO: ?
end
