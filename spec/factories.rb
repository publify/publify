# coding: utf-8
Factory.sequence :name do |n|
  "name_#{n}"
end

Factory.sequence :user do |n|
  "user#{n}"
end

Factory.sequence :guid do |n|
  "deadbeef#{n}"
end

Factory.sequence :label do |n|
  "lab_#{n}"
end

Factory.sequence :file_name do |f|
  "file_name_#{f}"
end

Factory.sequence :category do |n|
  "category_#{n}"
end

basetime = Time.now

Factory.sequence :time do |n|
  basetime - n
end

Factory.define :user do |u|
  u.login { Factory.next(:user) }
  u.email { Factory.next(:user) }
  u.name 'Bond'
  u.notify_via_email false
  u.notify_on_new_articles false
  u.notify_watch_my_articles false
  u.notify_on_comments false
  u.password 'top-secret'
end

def some_user
  User.find(:first) || Factory(:user)
end

Factory.define :article do |a|
  a.title 'A big article'
  a.body 'A content with several data'
  a.extended 'extended content for fun'
  a.guid { Factory.next(:guid) }
  a.permalink 'a-big-article'
  a.published_at '2005-01-01 02:00:00'
  a.updated_at { Factory.next(:time) }
  a.user { some_user }
  a.allow_comments true
  a.published true
  a.allow_pings true
end

def some_article
  Article.find(:first) || Factory(:article)
end

Factory.define :markdown, :class => :text_filter do |m|
  m.name "markdown"
  m.description "Markdown"
  m.markup 'markdown'
  m.filters '--- []'
  m.params '--- {}'
end

Factory.define :textile, :parent => :markdown do |m|
  m.name "textile"
  m.description "Textile"
  m.markup 'textile'
end

Factory.define :utf8article, :parent => :article do |u|
  u.title 'ルビー'
  u.permalink 'ルビー'
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
  b.hide_extended_on_rss true
  b.blog_name 'test blog'
  b.title_prefix 1
  b.limit_article_display 2
  b.sp_url_limit 3
  b.plugin_avatar ''
  b.blog_subtitle "test subtitles"
  b.limit_rss_display 10
  b.ping_urls "http://ping.example.com/ping http://alsoping.example.com/rpc/ping"
  b.geourl_location ""
  b.default_allow_pings false
  b.send_outbound_pings false
  b.sp_global true
  b.default_allow_comments true
  b.email_from "scott@sigkill.org"
  b.theme "typographic"
  b.text_filter "textile"
  b.sp_article_auto_close 0
  b.link_to_author false
  b.comment_text_filter "markdown"
  b.permalink_format "/%year%/%month%/%day%/%title%"
  b.use_canonical_url true
end


Factory.define :profile_admin, :class => :profile do |l|
  l.label {Factory.next(:label)}
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
  c.name {Factory.next(:category)}
  c.permalink {Factory.next(:category)}
  c.position 1
end

Factory.define :tag do |tag|
  tag.name {Factory.next(:name)}
end

Factory.define :resource do |r|
  r.filename {Factory.next(:file_name)}
  r.mime 'image/jpeg'
  r.size 110
end

Factory.define :redirect do |r|
  r.from_path 'foo/bar'
  r.to_path '/someplace/else'
end

Factory.define :comment do |c|
  c.published true
  c.article { some_article }
  c.author 'Bob Foo'
  c.url 'http://fakeurl.com'
  c.body 'Test <a href="http://fakeurl.co.uk">body</a>'
  c.created_at '2005-01-01 02:00:00'
  c.updated_at '2005-01-01 02:00:00'
  c.published_at '2005-01-01 02:00:00'
  c.guid '12313123123123123'
  c.state 'ham'
end

Factory.define :spam_comment, :parent => :comment do |c|
  c.state 'spam'
  c.published false
end

Factory.define :page do |p|
  p.name 'page_one'
  p.title 'Page One Title'
  p.body 'ho ho ho'
  p.created_at '2005-05-05 01:00:01'
  p.published_at '2005-05-05 01:00:01'
  p.updated_at '2005-05-05 01:00:01'
  p.user { some_user }
  p.published true
  p.state 'published'
end

Factory.define :trackback do |t|
  t.article { some_article }
  t.published true
  t.state 'ham'
  t.status_confirmed true
  t.blog_name 'Trackback Blog'
  t.title 'Trackback Entry'
  t.url 'http://www.example.com'
  t.excerpt 'This is an excerpt'
  t.guid 'dsafsadffsdsf'
end
