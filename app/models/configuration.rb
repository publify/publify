class Configuration < ConfigManager
  setting :blog_name, :string, 'My Shiny Weblog!'
  setting :default_allow_pings, :bool, false
  setting :default_allow_comments, :bool, true
  setting :sp_global, :bool, false
  setting :sp_article_auto_close, :int, 30
  setting :sp_url_limit, :int, 10
  setting :text_filter, :string, ''
  setting :comment_text_filter, :string, ''
  setting :limit_article_display, :int, 10
  setting :limit_rss_display, :int, 10  
end

def config
  $config ||= Configuration.new
end
