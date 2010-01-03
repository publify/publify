require 'factory_girl'

Factory.sequence :user do |n|
  "user#{n}"
end

Factory.sequence :guid do |n|
  "deadbeef#{n}"
end

Factory.define :user do |u|
  u.login { Factory.next(:user) }
  u.email 'some.where@out.there'
  u.notify_via_email false
  u.notify_on_new_articles false
  u.notify_watch_my_articles false
  u.notify_on_comments false
  u.password 'top-secret'
end

Factory.define :article do |a|
  a.title 'A big article'
  a.body 'A content with several data'
  a.guid { Factory.next(:guid) }
  a.permalink 'a-big-article'
  a.published_at Time.now
  # Using an existing user avoids the password reminder mail overhead
  a.user { User.find(:first) }
  #a.association :user, :factory => :user
end

Factory.define :second_article, :parent => :article do |a|
  a.title 'Another big article'
  a.published_at Time.now - 2.seconds
end

Factory.define :article_with_accent_in_html, :parent => :article do |a|
  a.title 'article with accent'
  a.body '&eacute;coute The future is cool!'
  a.permalink 'article-with-accent'
  a.published_at Time.now - 2.seconds
end

Factory.define :blog do |b|
  b.base_url 'http://myblog.net'
  b.blog_name 'test blog'
end

Factory.define :profile_admin, :class => :profile do |l|
  l.label 'admin'
  l.nicename 'Typo administrator'
  l.modules [:dashboard, :write, :content, :feedback, :themes, :sidebar, :users, :settings, :profile]
end
Factory.define :profile_publisher, :class => :profile do |l|
  l.label 'published'
  l.nicename 'Blog publisher'
  l.modules [:dashboard, :write, :content, :feedback, :profile]
end
Factory.define :profile_contributor, :class => :profile do |l|
  l.label 'contributor'
  l.nicename 'Contributor'
  l.modules [:dashboard, :profile]
end

Factory.define :category do |c|
  c.name 'SoftwareFactory'
  c.permalink 'softwarefactory'
  c.position 1
end
