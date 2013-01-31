# The Blog class represents the one and only blog.  It stores most
# configuration settings and is linked to most of the assorted content
# classes via has_many.
#
# Once upon a time, there were plans to make typo handle multiple blogs,
# but it never happened and typo is now firmly single-blog.
#
class Blog < ActiveRecord::Base
  include ConfigManager
  include Rails.application.routes.url_helpers

  attr_accessor :custom_permalink

  validate(:on => :create) { |blog|
    unless Blog.count.zero?
      blog.errors.add(:base, "There can only be one...")
    end
  }

  validates :blog_name, :presence => true

  serialize :settings, Hash

  # Description
  setting :blog_name,                  :string, 'My Shiny Weblog!'
  setting :blog_subtitle,              :string, ''
  setting :geourl_location,            :string, ''
  setting :canonical_server_url,       :string, ''  # Deprecated
  setting :lang,                       :string, 'en_US'
  setting :title_prefix,               :integer, 0 # Deprecated but needed for a migration

  # Spam
  setting :sp_global,                  :boolean, false
  setting :sp_article_auto_close,      :integer, 0
  setting :sp_url_limit,               :integer, 0
  setting :sp_akismet_key,             :string, ''
  setting :use_recaptcha,              :boolean, false

  # Mostly Behaviour
  setting :text_filter,                :string, 'markdown smartypants'
  setting :comment_text_filter,        :string, 'markdown smartypants'
  setting :limit_article_display,      :integer, 10
  setting :limit_rss_display,          :integer, 10
  setting :default_allow_pings,        :boolean, false
  setting :default_allow_comments,     :boolean, true
  setting :default_moderate_comments,  :boolean, false
  setting :link_to_author,             :boolean, false
  setting :show_extended_on_rss,       :boolean, true # deprecated but still needed for backward compatibility
  setting :hide_extended_on_rss,       :boolean, false
  setting :theme,                      :string, 'bootstrap'
  setting :plugin_avatar,              :string, ''
  setting :global_pings_disable,       :boolean, false
  setting :ping_urls,                  :string, "http://blogsearch.google.com/ping/RPC2\nhttp://rpc.technorati.com/rpc/ping\nhttp://ping.blo.gs/\nhttp://rpc.weblogs.com/RPC2"
  setting :send_outbound_pings,        :boolean, true
  setting :email_from,                 :string, 'typo@example.com'
  setting :editor,                     :integer, 'visual'
  setting :allow_signup,               :integer, 0
  setting :date_format,                :string, '%d/%m/%Y'
  setting :time_format,                :string, '%Hh%M'
  setting :image_thumb_size,           :integer, 125
  setting :image_medium_size,          :integer, 600

  # SEO
  setting :meta_description,           :string, ''
  setting :meta_keywords,              :string, ''
  setting :google_analytics,           :string, ''
  setting :feedburner_url,             :string, ''
  setting :rss_description,            :boolean, false
  setting :rss_description_text,       :string, "<hr /><p><small>Original article writen by %author% and published on <a href='%blog_url%'>%blog_name%</a> | <a href='%permalink_url%'>direct link to this article</a> | If you are reading this article elsewhere than <a href='%blog_url%'>%blog_name%</a>, it has been illegally reproduced and without proper authorization.</small></p>"
  setting :permalink_format,           :string, '/%year%/%month%/%day%/%title%'
  setting :robots,                     :string, ''
  setting :index_categories,           :boolean, true # deprecated but still needed for backward compatibility
  setting :unindex_categories,         :boolean, false
  setting :index_tags,                 :boolean, true # deprecated but still needed for backward compatibility
  setting :unindex_tags,               :boolean, false
  setting :admin_display_elements,     :integer, 10
  setting :google_verification,        :string, ''
  setting :nofollowify,                :boolean, true # deprecated but still needed for backward compatibility
  setting :dofollowify,                :boolean, false
  setting :use_canonical_url,          :boolean, false
  setting :use_meta_keyword,           :boolean, true
  setting :home_title_template,        :string, "%blog_name% | %blog_subtitle%" # spec OK
  setting :home_desc_template,         :string, "%blog_name% | %blog_subtitle% | %meta_keywords%" # OK
  setting :article_title_template,     :string, "%title% | %blog_name%" # spec OK
  setting :article_desc_template,      :string, "%excerpt%" #OK
  setting :page_title_template,        :string, "%title% | %blog_name%" # OK
  setting :page_desc_template,         :string, "%excerpt%" # OK
  setting :paginated_title_template,   :string, "%blog_name% | %blog_subtitle% %page%" # spec OK
  setting :paginated_desc_template,    :string, "%blog_name% | %blog_subtitle% | %meta_keywords% %page%" # OK
  setting :category_title_template,    :string, "Category: %name% | %blog_name% %page%" # Spec
  setting :category_desc_template,     :string, "%name% | %description% | %blog_subtitle% %page%" # Spec
  setting :tag_title_template,         :string, "Tag: %name% | %blog_name% %page%"
  setting :tag_desc_template,          :string, "%name% | %blog_name% | %blog_subtitle% %page%"
  setting :author_title_template,      :string, "%author% | %blog_name%" # OK
  setting :author_desc_template,       :string, "%author% | %blog_name% | %blog_subtitle%" # OK
  setting :archives_title_template,    :string, "Archives for %blog_name% %date% %page%" # specs OK
  setting :archives_desc_template,     :string, "Archives for %blog_name% %date% %page% %blog_subtitle%" # OK
  setting :search_title_template,      :string, "Results for %search% | %blog_name% %page%" # OK
  setting :search_desc_template,       :string, "Results for %search% | %blog_name% | %blog_subtitle% %page%" # OK
  setting :custom_tracking_field,      :string, ''
  # setting :meta_author_template,       :string, "%blog_name% | %nickname%"

  # Error handling
  setting :title_error_404,            :string, "Page not found"
  setting :msg_error_404,              :string, "<p>The page you are looking for has moved or does not exist.</p>"

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

  # The default Blog. This is the lowest-numbered blog, almost always
  # id==1. This should be the only blog as well.
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
  def current_theme reload = nil
    if reload
      @current_theme = nil
    end
    @current_theme ||= Theme.find(theme)
  end

  # Generate a URL based on the +base_url+.  This allows us to generate URLs
  # without needing a controller handy, so we can produce URLs from within models
  # where appropriate.
  #
  # It also caches the result in the RouteCache, so repeated URL generation
  # requests should be fast, as they bypass all of Rails' route logic.
  def url_for_with_base_url(options = {}, extra_params = {})
    case options
    when String
      if extra_params[:only_path]
        url_generated = root_path
      else
        url_generated = base_url
      end
      url_generated += "/#{options}" # They asked for 'url_for "/some/path"', so return it unedited.
      url_generated += "##{extra_params[:anchor]}" if extra_params[:anchor]
      url_generated
    when Hash
      unless RouteCache[options]
        options.reverse_merge!(:only_path => false, :controller => '',
                               :action => 'permalink',
                               :host => host_with_port,
                               :script_name => root_path)

        RouteCache[options] = url_for_without_base_url(options)
      end

      return RouteCache[options]
    else
      raise "Invalid URL in url_for: #{options.inspect}"
    end
  end

  alias_method_chain :url_for, :base_url

  # The URL for a static file.
  def file_url(filename)
    if CarrierWave.configure { |config| config.storage == CarrierWave::Storage::Fog }
      filename
    else
      url_for "files/#{filename}", :only_path => false
    end
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
    unless permalink_format =~ /(%title%)/
      errors.add(:permalink_format, _("You need a permalink format with an identifier : %%title%%"))
    end

    # A permalink cannot end in .atom or .rss. it's reserved for the feeds
    if permalink_format =~ /\.(atom|rss)$/
      errors.add(:permalink_format, _("Can't end in .rss or .atom. These are reserved to be used for feed URLs"))
    end
  end

  def root_path
    split_base_url[:root_path]
  end

  def text_filter_object
    text_filter.to_text_filter
  end

  def urls_to_ping_for(article)
    urls_to_ping = []
    self.ping_urls.gsub(/ +/, '').split(/[\n\r]+/).map(&:strip).delete_if{|u| article.already_ping?(u)}.uniq.each do |url|
      urls_to_ping << article.pings.build("url" => url)
    end
    urls_to_ping
  end

  private

  def protocol
    split_base_url[:protocol]
  end

  def host_with_port
    split_base_url[:host_with_port]
  end

  def split_base_url
    unless @split_base_url
      unless base_url =~ /(https?):\/\/([^\/]*)(.*)/
        raise "Invalid base_url: #{self.base_url}"
      end
      @split_base_url = { :protocol => $1, :host_with_port => $2,
        :root_path => $3.gsub(%r{/$},'') }
    end
    @split_base_url
  end

end

