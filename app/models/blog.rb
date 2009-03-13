# BlogRequest is a fake Request object, created so blog.url_for will work.
class BlogRequest

  attr_accessor :protocol, :host_with_port, :path, :symbolized_path_parameters, :relative_url_root

  def initialize(root)
    @protocol = @host_with_port = @path = ''
    @symbolized_path_parameters = {}
    @relative_url_root = root.gsub(%r{/$},'')
  end
end

# The Blog class represents one blog.  It stores most configuration settings
# and is linked to most of the assorted content classes via has_many.
#
# Typo decides which Blog object to use by searching for a Blog base_url that
# matches the base_url computed for each request.
class Blog < CachedModel
  include ConfigManager
  extend ActiveSupport::Memoizable

  validate_on_create { |blog|
    unless Blog.count.zero?
      blog.errors.add_to_base("There can only be one...")
    end
  }

  serialize :settings, Hash

  # Description
  setting :blog_name,                  :string, 'My Shiny Weblog!'
  setting :blog_subtitle,              :string, ''
  setting :title_prefix,               :integer, 0
  setting :geourl_location,            :string, ''
  setting :canonical_server_url,       :string, ''  # Deprecated
  setting :lang,                       :string, 'en_US'

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
  setting :text_filter,                :string, 'markdown smartypants'
  setting :comment_text_filter,        :string, 'markdown smartypants'
  setting :limit_article_display,      :integer, 10
  setting :limit_rss_display,          :integer, 10
  setting :default_allow_pings,        :boolean, false
  setting :default_allow_comments,     :boolean, true
  setting :default_moderate_comments,  :boolean, false
  setting :link_to_author,             :boolean, false
  setting :show_extended_on_rss,       :boolean, true
  setting :theme,                      :string, 'typographic'
  setting :use_gravatar,               :boolean, false
  setting :global_pings_disable,       :boolean, false
  setting :ping_urls,                  :string, "http://blogsearch.google.com/ping/RPC2\nhttp://rpc.technorati.com/rpc/ping\nhttp://ping.blo.gs/\nhttp://rpc.weblogs.com/RPC2"
  setting :send_outbound_pings,        :boolean, true
  setting :email_from,                 :string, 'typo@example.com'
  setting :editor,                     :integer, 'visual'
  setting :cache_option,               :string, 'caches_page'
  setting :allow_signup,               :integer, 0

  # SEO
  setting :meta_description,           :string, ''
  setting :meta_keywords,              :string, ''
  setting :google_analytics,           :string, ''
  setting :feedburner_url,             :string, ''
  setting :rss_description,            :boolean, false
  setting :permalink_format,           :string, '/%year%/%month%/%day%/%title%'
  setting :robots,                     :string, ''
  setting :index_categories,           :boolean, true
  setting :index_tags,                 :boolean, true
  #deprecation warning for plugins removal
  setting :deprecation_warning,        :integer, 1


  validate :permalink_has_identifier

  def initialize(*args)
    super
    # Yes, this is weird - PDC
    begin
      self.settings ||= {}
    rescue Exception => e
      self.settings = {}
    end
  end

  # Find the Blog that matches a specific base URL.  If no Blog object is found
  # that matches, then grab the default blog.  If *that* fails, then create a new
  # Blog.  The last case should only be used when Typo is first installed.
  def self.find_blog(base_url)
    Blog.default || Blog.create
  end

  # The default Blog.  This is the lowest-numbered blog, almost always id==1.
  def self.default
    find(:first, :order => 'id')
  rescue
    logger.warn 'You have no blog installed.'
    nil
  end

  # In settings with :article_id
  def ping_article!(settings)
    unless global_pings_enabled? && settings.has_key?(:url) && settings.has_key?(:article_id)
      throw :error, "Invalid trackback or trackbacks not enabled"
    end
    settings[:blog_id] = self.id
    article = Article.find(settings[:article_id])
    unless article.allow_pings?
      throw :error, "Trackback not saved"
    end
    article.trackbacks.create!(settings)
  end

  def global_pings_enabled?
    ! global_pings_disable?
  end

  # Check that all required blog settings have a value.
  def configured?
    settings.has_key?('blog_name')
  end

  # The +Theme+ object for the current theme.
  def current_theme
    Theme.find(theme)
  end
  memoize :current_theme

  # Generate a URL based on the +base_url+.  This allows us to generate URLs
  # without needing a controller handy, so we can produce URLs from within models
  # where appropriate.
  #
  # It also uses our new RouteCache, so repeated URL generation requests should be
  # fast, as they bypass all of Rails' route logic.
  def url_for(options = {}, extra_params = {})
    case options
    when String
      url_generated = ''
      url_generated = self.base_url if extra_params[:only_path]
      url_generated += "/#{options}" # They asked for 'url_for "/some/path"', so return it unedited.
      url_generated += "##{extra_params[:anchor]}" if extra_params[:anchor]
      url_generated
    when Hash
      unless RouteCache[options]
        options.reverse_merge!(:only_path => true, :controller => '',
                               :action => 'permalink')
        # In Rails > 2.2 the rewrite method use
        # ActionController::Base.relative_url_root instead of
        # @request.relative_url_root
        if ActionController::Base.relative_url_root.nil?
          old_relative_url = nil
        else
          old_relative_url = ActionController::Base.relative_url_root.dup
        end
        ActionController::Base.relative_url_root = self.base_url
        @url ||= ActionController::UrlRewriter.new(BlogRequest.new(self.base_url), {})
        RouteCache[options] = @url.rewrite(options)
        ActionController::Base.relative_url_root = old_relative_url
      end

      return RouteCache[options]
    else
      raise "Invalid URL in url_for: #{options.inspect}"
    end
  end

  # The URL for a static file.
  def file_url(filename)
    "#{base_url}/files/#{filename}"
  end

  # The base server URL.
  def server_url
    base_url
  end

  # Deprecated
  typo_deprecate :canonical_server_url => :base_url

  def [](key)  # :nodoc:
    typo_deprecated "Use blog.#{key}"
    self.send(key)
  end

  def []=(key, value)  # :nodoc:
    typo_deprecated "Use blog.#{key}="
    self.send("#{key}=", value)
  end

  def has_key?(key)  # :nodoc:
    typo_deprecated "Why?"
    self.class.fields.has_key?(key.to_s)
  end

  def find_already_published(content_type)  # :nodoc:
    typo_deprecated "Use #{content_type}.find_already_published"
    content_type.to_s.camelize.constantize.find_already_published
  end

  def current_theme_path  # :nodoc:
    typo_deprecated "use current_theme.path"
    Theme.themes_root + "/" + theme
  end

  def requested_article(params)
    Article.find_by_params_hash(params)
  end

  def articles_matching(query, args={})
    Article.search(query, args)
  end

  def rss_limit_params
    limit = limit_rss_display.to_i
    return limit.zero? \
      ? {} \
      : {:limit => limit}
  end

  def permalink_has_identifier
    unless permalink_format =~ /(%year%|%month%|%day%|%title%)/
      errors.add(:permalink_format, _('You need a Format of permalink with an identifier : %%month%%, %%year%%, %%day%%, %%title%%'))
    end

    # A permalink can be finish by .atom or .rss. it's reserved to feed
    if permalink_format =~ /\.(atom|rss)$/
      errors.add(:permalink_format, _("Can't finish by .rss or .atom. It's reserved to be use by feed"))
    end
  end

end

