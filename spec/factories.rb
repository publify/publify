# coding: utf-8

# Helper methods
def some_user
  User.find(:first) || FactoryGirl.create(:user)
end

def some_article
  Article.find(:first) || FactoryGirl.create(:article)
end

# Factory definitions
FactoryGirl.define do
  sequence :name do |n|
    "name_#{n}"
  end

  sequence :user do |n|
    "user#{n}"
  end

  sequence :guid do |n|
    "deadbeef#{n}"
  end

  sequence :label do |n|
    "lab_#{n}"
  end

  sequence :file_name do |f|
    "file_name_#{f}"
  end

  sequence :category do |n|
    "c_#{n}"
  end

  basetime = Time.now

  sequence :time do |n|
    basetime - n
  end

  factory :user do |u|
    u.login { FactoryGirl.generate(:user) }
    u.email { FactoryGirl.generate(:user) }
    u.name 'Bond'
    u.notify_via_email false
    u.notify_on_new_articles false
    u.notify_on_comments false
    u.password 'top-secret'
    u.settings({})
    u.state 'active'
    u.profile {FactoryGirl.create(:profile)}
    u.text_filter {FactoryGirl.create(:textile)}
  end

  factory :article do |a|
    a.title 'A big article'
    a.body 'A content with several data'
    a.extended 'extended content for fun'
    a.guid { FactoryGirl.generate(:guid) }
    a.permalink 'a-big-article'
    a.published_at '2005-01-01 02:00:00'
    a.updated_at { FactoryGirl.generate(:time) }
    a.user { some_user }
    a.allow_comments true
    a.published true
    a.allow_pings true
  end

  factory :unpublished_article, :parent => :article do |a|
    a.published_at nil
    a.published false
  end

  factory :post_type do |p|
    p.name 'foobar'
    p.description "Some description"
  end

  factory :markdown, :class => :text_filter do |m|
    m.name "markdown"
    m.description "Markdown"
    m.markup 'markdown'
    m.filters '--- []'
    m.params '--- {}'
  end

  factory :smartypants, :parent => :markdown do |m|
    m.name "smartypants"
    m.description "SmartyPants"
    m.markup 'none'
    m.filters %q{ [:smartypants].to_yaml.inspect }
  end

  factory 'markdown smartypants', :parent => :smartypants do |m|
    m.name "markdown smartypants"
    m.description "Markdown with SmartyPants"
    m.markup 'markdown'
    m.filters [:smartypants]
  end

  factory :textile, :parent => :markdown do |m|
    m.name "textile"
    m.description "Textile"
    m.markup 'textile'
  end

  factory :none, :parent => :markdown do |m|
    m.name "none"
    m.description "None"
    m.markup 'none'
  end

  factory :utf8article, :parent => :article do |u|
    u.title 'ルビー'
    u.permalink 'ルビー'
  end

  factory :second_article, :parent => :article do |a|
    a.title 'Another big article'
    a.published_at Time.now - 2.seconds
  end

  factory :article_with_accent_in_html, :parent => :article do |a|
    a.title 'article with accent'
    a.body '&eacute;coute The future is cool!'
    a.permalink 'article-with-accent'
    a.published_at Time.now - 2.seconds
  end

  factory :blog do |b|
    b.base_url 'http://myblog.net'
    b.hide_extended_on_rss true
    b.blog_name 'test blog'
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
    b.text_filter FactoryGirl.create(:textile).name
    b.sp_article_auto_close 0
    b.link_to_author false
    b.comment_text_filter FactoryGirl.create(:markdown).name
    b.permalink_format "/%year%/%month%/%day%/%title%"
    b.use_canonical_url true
  end

  factory :profile, :class => :profile do |l|
    l.label {FactoryGirl.generate(:label)}
    l.nicename 'Typo contributor'
    l.modules [:dashboard, :profile]
  end

  factory :profile_admin, :parent => :profile do |l|
    l.label {FactoryGirl.generate(:label)}
    l.nicename 'Typo administrator'
    l.modules [:dashboard, :write, :articles, :pages, :feedback, :themes, :sidebar, :users, :seo, :media, :settings, :profile]
  end

  factory :profile_publisher, :parent => :profile do |l|
    l.label 'publisher'
    l.nicename 'Blog publisher'
    l.modules [:users, :dashboard, :write, :articles, :pages, :feedback, :media]
  end

  factory :profile_contributor, :parent => :profile do |l|
  end

  factory :category do |c|
    c.name {FactoryGirl.generate(:category)}
    c.permalink {FactoryGirl.generate(:category)}
    c.position 1
  end

  factory :tag do |tag|
    tag.name {FactoryGirl.generate(:name)}
    tag.display_name { |a| a.name }
  end

  factory :resource do |r|
    r.filename {FactoryGirl.generate(:file_name)}
    r.mime 'image/jpeg'
    r.size 110
  end

  factory :redirect do |r|
    r.from_path 'foo/bar'
    r.to_path '/someplace/else'
  end

  factory :comment do |c|
    c.published true
    c.article { some_article }
    c.text_filter {FactoryGirl.create(:textile)}
    c.author 'Bob Foo'
    c.url 'http://fakeurl.com'
    c.body 'Test <a href="http://fakeurl.co.uk">body</a>'
    c.created_at '2005-01-01 02:00:00'
    c.updated_at '2005-01-01 02:00:00'
    c.published_at '2005-01-01 02:00:00'
    c.guid '12313123123123123'
    c.state 'ham'
  end

  factory :spam_comment, :parent => :comment do |c|
    c.state 'spam'
    c.published false
  end

  factory :page do |p|
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

  factory :trackback do |t|
    t.published true
    t.state 'ham'
    t.article { some_article }
    t.status_confirmed true
    t.blog_name 'Trackback Blog'
    t.title 'Trackback Entry'
    t.url 'http://www.example.com'
    t.excerpt 'This is an excerpt'
    t.guid 'dsafsadffsdsf'
    t.created_at Time.now
    t.updated_at Time.now
  end
end
