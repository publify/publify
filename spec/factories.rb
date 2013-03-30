# coding: utf-8

# Factory definitions
FactoryGirl.define do
  sequence :name do |n|
    "name_#{n}"
  end

  sequence :user do |n|
    "user#{n}"
  end

  sequence :email do |n|
    "user#{n}@example.com"
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

  factory :user do
    login { FactoryGirl.generate(:user) }
    email { generate(:email) }
    name 'Bond'
    notify_via_email false
    notify_on_new_articles false
    notify_on_comments false
    password 'top-secret'
    settings({})
    state 'active'
    profile
    editor 'simple'
    association :text_filter, factory: :textile
  end

  factory :article do
    title 'A big article'
    body 'A content with several data'
    extended 'extended content for fun'
    guid
    permalink 'a-big-article'
    published_at DateTime.new(2005,1,1,2,0,0)
    user
    categories []
    tags []
    published_comments []
    published_trackbacks []
    allow_comments true
    published true
    allow_pings true
  end

  factory :unpublished_article, :parent => :article do |a|
    a.published_at nil
    a.published false
  end

  factory :content do
  end

  factory :post_type do |p|
    p.name 'foobar'
    p.description "Some description"
  end

  factory :markdown, :class => :text_filter do
    name "markdown"
    description "Markdown"
    markup 'markdown'
    filters '--- []'
    params '--- {}'

    after :stub do |filter|
      TextFilter.stub(:find_by_name).with(filter.name) { filter }
    end
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
    name "none"
    description "None"
    markup 'none'

    after :stub do |filter|
      TextFilter.stub(:find_by_name).with('') { nil }
    end
  end

  factory :utf8article, :parent => :article do |u|
    u.title 'ルビー'
    u.permalink 'ルビー'
  end

  factory :second_article, :parent => :article do |a|
    a.title 'Another big article'
  end

  factory :article_with_accent_in_html, :parent => :article do |a|
    a.title 'article with accent'
    a.body '&eacute;coute The future is cool!'
    a.permalink 'article-with-accent'
  end

  factory :blog do
    base_url 'http://myblog.net'
    hide_extended_on_rss true
    blog_name 'test blog'
    limit_article_display 2
    sp_url_limit 3
    plugin_avatar ''
    blog_subtitle "test subtitles"
    limit_rss_display 10
    ping_urls "http://ping.example.com/ping
http://alsoping.example.com/rpc/ping"
    geourl_location ""
    default_allow_pings false
    send_outbound_pings false
    sp_global true
    default_allow_comments true
    email_from "scott@sigkill.org"
    theme "typographic"
    association :text_filter, factory: :textile
    sp_article_auto_close 0
    link_to_author false
    comment_text_filter "markdown" #FactoryGirl.create(:markdown).name
    permalink_format "/%year%/%month%/%day%/%title%"
    use_canonical_url true
    lang "en_US"

    after :stub do |blog|
      Blog.stub(:default) { blog }
      [blog.text_filter, blog.comment_text_filter].uniq.each do |filter|
        build_stubbed filter
      end
    end
  end

  factory :profile, :class => :profile do |l|
    l.label {FactoryGirl.generate(:label)}
    l.nicename 'Typo contributor'
    l.modules [:dashboard, :profile]
  end

  factory :profile_admin, parent: :profile do
    label Profile::ADMIN
    nicename 'Typo administrator'
    modules [ :dashboard, :write, :articles, :pages, :feedback, :themes,
              :sidebar, :users, :seo, :media, :settings, :profile ]
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
    r.upload {FactoryGirl.generate(:file_name)}
    r.mime 'image/jpeg'
    r.size 110
  end

  factory :redirect do |r|
    r.from_path 'foo/bar'
    r.to_path '/someplace/else'
  end

  factory :comment do
    published true
    article
    text_filter {FactoryGirl.create(:textile)}
    author 'Bob Foo'
    url 'http://fakeurl.com'
    body 'Test <a href="http://fakeurl.co.uk">body</a>'
    created_at '2005-01-01 02:00:00'
    updated_at '2005-01-01 02:00:00'
    published_at '2005-01-01 02:00:00'
    guid
    state 'ham'
  end

  factory :spam_comment, :parent => :comment do |c|
    c.state 'spam'
    c.published false
  end

  factory :ham_comment, :parent => :comment do |c|
    c.state 'ham'
    c.published false
  end

  factory :page do
    name 'page_one'
    title 'Page One Title'
    body 'ho ho ho'
    created_at '2005-05-05 01:00:01'
    published_at '2005-05-05 01:00:01'
    updated_at '2005-05-05 01:00:01'
    user
    published true
    state 'published'
  end

  factory :trackback do |t|
    published true
    state 'ham'
    article
    status_confirmed true
    blog_name 'Trackback Blog'
    title 'Trackback Entry'
    url 'http://www.example.com'
    excerpt 'This is an excerpt'
    guid 'dsafsadffsdsf'
    created_at Time.now
    updated_at Time.now
  end
end
