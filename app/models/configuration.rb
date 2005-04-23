class Configuration < ConfigManager
  setting :blog_name, :string, "Name of the blog"
  setting :default_allow_pings, :bool, "Allow trackbacks by default"  
  setting :default_allow_comments, :bool, "Allow comments by default"  
  setting :sp_global, :bool, "Use SpamProtection functionality"
  setting :sp_article_auto_close, :int, "Auto-close ability to comment/trackback articles after X days"
  setting :sp_url_limit, :int, "Limit for URLs in comments and trackbacks"
  setting :text_filter, :string, "Default HTML transformation style"
end

def config
  $config ||= Configuration.new
end
