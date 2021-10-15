FactoryBot.define do
  factory :blog do
    base_url { "http://test.host/blog" }
    hide_extended_on_rss { true }
    blog_name { "test blog" }
    limit_article_display { 2 }
    sp_url_limit { 3 }
    plugin_avatar { "" }
    blog_subtitle { "test subtitle" }
    limit_rss_display { 10 }
    geourl_location { "" }
    default_allow_pings { false }
    send_outbound_pings { false }
    sp_global { true }
    default_allow_comments { true }
    email_from { "scott@sigkill.org" }
    sp_article_auto_close { 0 }
    permalink_format { "/%year%/%month%/%day%/%title%" }
    rss_description_text { "rss description text" }
    lang { "en_US" }
  end
end
