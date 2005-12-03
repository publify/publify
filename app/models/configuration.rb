class Configuration < ConfigManager
  setting :blog_name, :string, 'My Shiny Weblog!'
  setting :blog_subtitle, :string, ''
  setting :default_allow_pings, :bool, false
  setting :default_allow_comments, :bool, true
  setting :sp_global, :bool, false
  setting :sp_article_auto_close, :int, 0
  setting :sp_allow_non_ajax_comments, :bool, true
  setting :sp_url_limit, :int, 0
  setting :itunes_explicit, :bool, false
  setting :itunes_author, :string, ''
  setting :itunes_owner, :string, ''
  setting :itunes_email, :string, ''
  setting :itunes_name, :string, ''
  setting :itunes_copyright, :string, ''
  setting :text_filter, :string, ''
  setting :comment_text_filter, :string, ''
  setting :limit_article_display, :int, 10
  setting :limit_rss_display, :int, 10  
  setting :geourl_location, :string, ''
  setting :link_to_author, :bool, false
  setting :show_extended_on_rss, :bool, true
  setting :theme, :string, 'azure'
  setting :use_gravatar, :bool, false
  setting :ping_urls, :string, "http://rpc.technorati.com/rpc/ping\nhttp://ping.blo.gs/\nhttp://rpc.weblogs.com/RPC2"
  setting :send_outbound_pings, :bool, true
  setting :email_from, :string, 'scott@sigkill.org'
  setting :jabber_address, :string, ''
  setting :jabber_password, :string, ''
end

def config
  $config ||= Configuration.new
end
