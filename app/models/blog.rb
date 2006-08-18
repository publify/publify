# BlogRequest is a fake Request object, created so blog.url_for will work.
# This isn't enabled yet, but it will be soon...
class BlogRequest
  include Reloadable

  attr_accessor :protocol, :host_with_port, :path, :symbolized_path_parameters, :relative_url_root

  def initialize(root)
    @protocol = @host_with_port = @path = ''
    @symbolized_path_parameters = {}
    @relative_url_root = root.gsub(%r{/^},'')
  end
end

class Blog < ActiveRecord::Base
  include ConfigManager

  has_many :contents
  has_many :trackbacks
  has_many :articles
  has_many :comments
  has_many :pages, :order => "id DESC"
  has_many(:published_articles, :class_name => "Article",
           :conditions => ["published = ?", true],
           :include => [:categories, :tags],
           :order => "contents.created_at DESC") do
    def before(date = Time.now)
      find(:all, :conditions => ["contents.created_at < ?", date])
    end
  end

  has_many :pages
  has_many :comments

  serialize :settings, Hash

  # Description
  setting :blog_name,                  :string, 'My Shiny Weblog!'
  setting :blog_subtitle,              :string, ''
  setting :title_prefix,               :boolean, false
  setting :geourl_location,            :string, ''
  setting :canonical_server_url,       :string, ''

  # Spam
  setting :sp_global,                  :boolean, false
  setting :sp_article_auto_close,      :integer, 0
  setting :sp_allow_non_ajax_comments, :boolean, true
  setting :sp_url_limit,               :integer, 0
  setting :sp_akismet_key,             :string, ''

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
  setting :global_pings_disable,       :boolean, false
  setting :ping_urls,                  :string, "http://rpc.technorati.com/rpc/ping\nhttp://ping.blo.gs/\nhttp://rpc.weblogs.com/RPC2"
  setting :send_outbound_pings,        :boolean, true
  setting :email_from,                 :string, 'typo@example.com'

  # Jabber config
  setting :jabber_address,             :string, ''
  setting :jabber_password,            :string, ''

  def find_already_published(content_type)
    self.send(content_type).find_already_published
  end
  
  # Find the Blog that matches a specific base URL.  If no Blog object is found
  # that matches, then grab the default blog.  If *that* fails, then create a new
  # Blog.  The last case should only be used when Typo is first installed.
  def self.find_blog(base_url)
    Blog.find_by_base_url(base_url) || Blog.default || Blog.new
  end

  def ping_article!(settings)
    settings[:blog_id] = self.id
    article_id = settings[:id]
    settings.delete(:id)
    trackback = published_articles.find(article_id).trackbacks.create!(settings)
  end

  # Check that all required blog settings have a value.
  def is_ok?
    settings.has_key?('blog_name')
  end

  # Axe?
  def [](key)
    typo_deprecated "Why?"
    self.send(key)
  end

  # Axe?
  def []=(key, value)
    typo_deprecated "Why?"
    self.send("#{key}=", value)
  end

  # Axe?
  def has_key?(key)
    typo_deprecated "Why?"
    self.class.fields.has_key?(key.to_s)
  end

  def initialize(*args)
    super
    self.settings ||= { }
  end

  # The default Blog.  This is the lowest-numbered blog, almost always id=1.
  def self.default
    find(:first, :order => 'id')
  end

  # The path to the currently-active theme.
  def current_theme_path
    Theme.themes_root + "/" + theme
  end

  # Axe?
  def current_theme
    Theme.theme_from_path(current_theme_path)
  end

  # Generate a URL based on the canonical_server_url.  This allows us to generate URLs
  # without needing a controller handy, so we can produce URLs from within models
  # where appropriate.
  #
  # It also uses our new RouteCache, so repeated URL generation requests should be
  # fast, as they bypass all of Rails' route logic.
  def url_for(options = {}, *extra_params)
    case options
    when String then options
    when Hash
      unless RouteCache[options]
        options.reverse_merge!(:only_path => true, :controller => '/articles',
                               :action => 'permalink')
        @url ||= ActionController::UrlRewriter.new(BlogRequest.new(self.canonical_server_url), {})
        RouteCache[options] = @url.rewrite(options)
      end
      
      return RouteCache[options]
    else
      raise "Invalid URL in url_for: #{options.inspect}"
    end
  end
  
  # The URL for a static file.  This should probably be rewritten, as there
  # is no 'files' controller.
  def file_url(filename)
    url_for(:controller => 'files', :action => filename)
  end
  
  # The base server URL.
  def server_url
    base_url
  end
end

