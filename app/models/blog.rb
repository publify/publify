require 'config_manager'
class Blog < ActiveRecord::Base
  include ConfigManager

  serialize :settings, Hash

  # Description
  setting :blog_name,                  :string, 'My Shiny Weblog!'
  setting :blog_subtitle,              :string, ''
  setting :geourl_location,            :string, ''

  # Spam
  setting :sp_global,                  :boolean, false
  setting :sp_article_auto_close,      :integer, 0
  setting :sp_allow_non_ajax_comments, :boolean, true
  setting :sp_url_limit,               :integer, 0

  # Podcasting
  setting :itunes_explicit,            :boolean, false
  setting :itunes_author,              :string, ''
  setting :itunes_subtitle,            :string, ''
  setting :itunes_summary,             :string, ''
  setting :itunes_owner,               :string, ''
  setting :itunes_email,               :string, ''
  setting :itunes_name,                :string, ''
  setting :itunes_copyright,           :string, ''

  # Mostly Behaviour
  setting :text_filter,                :string, ''
  setting :comment_text_filter,        :string, ''
  setting :limit_article_display,      :integer, 10
  setting :limit_rss_display,          :integer, 10
  setting :default_allow_pings,        :boolean, false
  setting :default_allow_comments,     :boolean, true
  setting :link_to_author,             :boolean, false
  setting :show_extended_on_rss,       :boolean, true
  setting :theme,                      :string, 'azure'
  setting :use_gravatar,               :boolean, false
  setting :ping_urls,                  :string, "http://rpc.technorati.com/rpc/ping\nhttp://ping.blo.gs/\nhttp://rpc.weblogs.com/RPC2"
  setting :send_outbound_pings,        :boolean, true
  setting :email_from,                 :string, 'scott@sigkill.org'

  # Jabber config
  setting :jabber_address,             :string, ''
  setting :jabber_password,            :string, ''


  def is_ok?
    settings.has_key?('blog_name')
  end

  def [](key)
    self.send(key)
  end

  def []=(key, value)
    self.send("#{key}=", value)
  end

  def has_key?(key)
    self.class.fields.has_key?(key.to_s)
  end

  def initialize(*args)
    super
    self.settings ||= { }
  end
end



def config
  this_blog
end

def this_blog
  $blog || (Blog.find(DEFAULT_BLOG_ID) rescue nil) || Blog.find(:first) || Blog.create!
end
