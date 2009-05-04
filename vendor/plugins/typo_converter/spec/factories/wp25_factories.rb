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
