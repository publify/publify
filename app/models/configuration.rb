class Configuration < ConfigManager
  setting :blog_name, :string, 'My Shiny Weblog!'
  setting :blog_subtitle, :string, ''
  setting :default_allow_pings, :bool, false
  setting :default_allow_comments, :bool, true
  setting :sp_global, :bool, false
  setting :sp_article_auto_close, :int, 0
  setting :sp_url_limit, :int, 0
  setting :text_filter, :string, ''
  setting :comment_text_filter, :string, ''
  setting :limit_article_display, :int, 10
  setting :limit_rss_display, :int, 10  
  setting :geourl_location, :string, ''
  setting :link_to_author, :bool, false
  setting :theme, :string, 'azure'
end

def config
  $config ||= Configuration.new
end
