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

# Don't use this one, it's just an abstract superclass.
Factory.define 'WP25/content', :class => WP25::Post do |p|
  now = Time.now
  p.post_date now
  # TODO: figure out how to handle GMT conversion
  p.post_date_gmt {|p| p.post_date }
  p.post_modified {|p| p.post_date }
  p.post_modified_gmt {|p| p.post_modified }
  p.to_ping '' # TODO: ?
  p.pinged '' # TODO: ?
  p.post_content_filtered {|p| p.post_content + ' [filtered]'} # TODO: ?
end

Factory.define 'WP25/post', :parent => 'WP25/content' do |p|
  p.post_type 'post'
  p.post_title 'Default Title'
  p.post_content 'This is default content.'
  p.post_excerpt 'Default excerpt.'
end

Factory.sequence(:page) {|n| n} # dur

Factory.define 'WP25/page', :parent => 'WP25/content' do |p|
  p.post_type 'page'
  p.post_title 'Default Page Title'
  p.post_content 'This is default page content.'
  p.post_excerpt 'Default page excerpt.'
  p.post_name {|p| "#{Factory.next(:page)}-#{p.post_title.to_url}"}
end

Factory.define 'WP25/comment', :class => WP25::Comment do |c|
  now = Time.now
  c.comment_author {|c| c.user ? c.user.display_name : nil}
  c.comment_date now
  # TODO: figure out how to handle GMT conversion
  c.comment_date_gmt {|c| c.comment_date}
  c.comment_content 'This is my comment.'
end

Factory.define 'WP25/term', :class => WP25::Term do |t|
  t.slug {|t| t.name.to_url}
end

Factory.define 'WP25/tag', :parent => 'WP25/term' do |t|
  t.name 'A Tag'
  # TODO: use associations to place tags in the taxonomy
end

Factory.define 'WP25/category', :parent => 'WP25/term' do |t|
  t.name 'A Category'
  # TODO: use associations to place categories in the taxonomy
end

Factory.define 'WP25/term_taxonomy', :class => WP25::TermTaxonomy do |tt|
  tt.description ''
end

Factory.define 'WP25/term_relationship', :class => WP25::TermRelationship do |tr|

end
