# frozen_string_literal: true

# The Blog class represents the one and only blog.  It stores most
# configuration settings and is linked to most of the assorted content
# classes via has_many.
#
# Once upon a time, there were plans to make publify handle multiple blogs,
# but it never happened and publify is now firmly single-blog.
#
class Blog < ApplicationRecord
  include ConfigManager
  include StringLengthLimit

  include Rails.application.routes.url_helpers

  has_many :contents
  has_many :articles
  has_many :feedback, through: :articles

  has_many :published_articles, ->() { published }, class_name: "Article"

  has_many :pages
  has_many :tags
  has_many :notes

  has_many :redirects
  has_many :sidebars, ->() { order("active_position ASC") }

  attr_accessor :custom_permalink

  default_scope -> { order("id") }

  validates :blog_name, presence: true

  serialize :settings, Hash

  # Description
  setting :blog_name, :string, "My Shiny Weblog!"
  setting :blog_subtitle, :string, ""
  setting :geourl_location, :string, ""
  setting :canonical_server_url, :string, "" # Deprecated
  setting :lang, :string, "en_US"

  # Spam
  setting :sp_global, :boolean, false
  setting :sp_article_auto_close, :integer, 0
  setting :sp_url_limit, :integer, 0
  setting :sp_akismet_key, :string, ""
  setting :use_recaptcha, :boolean, false

  # Mostly Behaviour
  setting :text_filter, :string, "markdown smartypants"
  setting :comment_text_filter, :string, "markdown smartypants"
  setting :limit_article_display, :integer, 10
  setting :limit_archives_display, :integer, 20
  setting :limit_rss_display, :integer, 10
  setting :default_allow_pings, :boolean, false
  setting :default_allow_comments, :boolean, true
  setting :default_moderate_comments, :boolean, false
  # deprecated but still needed for backward compatibility
  setting :show_extended_on_rss, :boolean, true
  setting :hide_extended_on_rss, :boolean, false
  setting :theme, :string, "plain"
  setting :plugin_avatar, :string, ""
  setting :global_pings_disable, :boolean, false
  setting :send_outbound_pings, :boolean, true
  setting :email_from, :string, "publify@example.com"
  setting :allow_signup, :integer, 0
  setting :date_format, :string, "%d/%m/%Y"
  setting :time_format, :string, "%Hh%M"
  setting :image_avatar_size, :integer, 48
  setting :image_thumb_size, :integer, 125
  setting :image_medium_size, :integer, 600

  # SEO
  setting :meta_description, :text, ""
  setting :meta_keywords, :string, ""
  setting :google_analytics, :string, ""
  setting :rss_description, :boolean, false
  setting :rss_description_text, :text, <<-HTML.strip_heredoc
    <hr />
    <p><small>Original article written by %author% and published on <a href='%blog_url%'>%blog_name%</a>
    | <a href='%permalink_url%'>direct link to this article</a>
    | If you are reading this article anywhere other than on <a href='%blog_url%'>%blog_name%</a>,
      it has been illegally reproduced and without proper authorization.</small></p>
  HTML
  setting :permalink_format, :string, "/%year%/%month%/%day%/%title%"
  setting :robots, :text, 'User-agent: *\nAllow: /\nDisallow: /admin\n'
  setting :humans, :text, <<-TEXT.strip_heredoc
    /* TEAM */
    Your title: Your name.
    Site: email, link to a contact form, etc.
    Twitter: your Twitter username.

    /* SITE */
    Software: Publify [https://publify.github.io/] #{PublifyCore::VERSION}
  TEXT
  # deprecated but still needed for backward compatibility
  setting :index_categories, :boolean, true
  setting :unindex_categories, :boolean, false
  # deprecated but still needed for backward compatibility
  setting :index_tags, :boolean, true
  setting :unindex_tags, :boolean, false
  setting :admin_display_elements, :integer, 10
  setting :google_verification, :string, ""
  # deprecated but still needed for backward compatibility
  setting :nofollowify, :boolean, true
  setting :dofollowify, :boolean, false
  setting :use_meta_keyword, :boolean, true
  setting :home_title_template, :string, "%blog_name% | %blog_subtitle%"
  setting :home_desc_template, :string, "%blog_name% | %blog_subtitle% | %meta_keywords%"
  setting :article_title_template, :string, "%title% | %blog_name%"
  setting :article_desc_template, :string, "%excerpt%"
  setting :page_title_template, :string, "%title% | %blog_name%"
  setting :page_desc_template, :string, "%excerpt%"
  setting :paginated_title_template, :string, "%blog_name% | %blog_subtitle% %page%"
  setting :paginated_desc_template, :string,
          "%blog_name% | %blog_subtitle% | %meta_keywords% %page%"
  setting :tag_title_template, :string, "Tag: %name% | %blog_name% %page%"
  setting :tag_desc_template, :string, "%name% | %blog_name% | %blog_subtitle% %page%"
  setting :author_title_template, :string, "%author% | %blog_name%"
  setting :author_desc_template, :string, "%author% | %blog_name% | %blog_subtitle%"
  setting :archives_title_template, :string, "Archives for %blog_name% %date% %page%"
  setting :archives_desc_template, :string,
          "Archives for %blog_name% %date% %page% %blog_subtitle%"
  setting :search_title_template, :string, "Results for %search% | %blog_name% %page%"
  setting :search_desc_template, :string,
          "Results for %search% | %blog_name% | %blog_subtitle% %page%"
  setting :statuses_title_template, :string, "Notes | %blog_name% %page%"
  setting :statuses_desc_template, :string, "Notes | %blog_name% | %blog_subtitle% %page%"
  setting :status_title_template, :string, "%body% | %blog_name%"
  setting :status_desc_template, :string, "%excerpt%"

  setting :custom_tracking_field, :string, ""
  # setting :meta_author_template,       :string, "%blog_name% | %nickname%"

  setting :twitter_consumer_key, :string, ""
  setting :twitter_consumer_secret, :string, ""
  setting :custom_url_shortener, :string, ""
  setting :statuses_in_timeline, :boolean, true

  validate :permalink_has_identifier
  # validates :base_url, presence: true
  validates_default_string_length :base_url

  # Find the Blog that matches a specific base URL. If no Blog object is found
  # that matches, then grab the first blog. If *that* fails, then create a new
  # Blog. The last case should only be used when Publify is first installed.
  def self.find_blog(base_url)
    Blog.find_by(base_url: base_url) || Blog.first || Blog.new
  end

  def global_pings_enabled?
    !global_pings_disable?
  end

  # Check that all required blog settings have a value.
  def configured?
    settings.key?("blog_name")
  end

  # The +Theme+ object for the current theme.
  def current_theme(reload = nil)
    @current_theme = nil if reload
    @current_theme ||= Theme.find(theme) || Theme.new("", "")
  end

  module BasedUrlFor
    # Generate a URL based on the +base_url+.  This allows us to generate URLs
    # without needing a controller handy, so we can produce URLs from within models
    # where appropriate.
    #
    # It also caches the result in the Rails cache, so repeated URL generation
    # requests should be fast, as they bypass all of Rails' route logic.
    def url_for(options = {}, extra_params = {})
      case options
      when String
        options = options.sub(%r{^/}, "")
        url_generated = if extra_params[:only_path]
                          root_path
                        else
                          base_url
                        end
        # They asked for 'url_for "/some/path"', so return it unedited.
        url_generated += "/#{options}"
        url_generated += "##{extra_params[:anchor]}" if extra_params[:anchor]
        url_generated
      when Hash
        merged_opts = options.reverse_merge!(only_path: false, controller: "",
                                             action: "permalink",
                                             host: host_with_port,
                                             script_name: root_path)
        cache_key = merged_opts.values.prepend("blog-urlfor-withbaseurl").join("-")
        unless Rails.cache.exist?(cache_key)
          Rails.cache.write(cache_key, super(merged_opts))
        end
        Rails.cache.read(cache_key)
      else
        raise "Invalid URL in url_for: #{options.inspect}"
      end
    end
  end

  prepend BasedUrlFor

  # The URL for a static file.
  def file_url(filename)
    if CarrierWave.configure { |config| config.storage.name == "CarrierWave::Storage::Fog" }
      filename
    else
      url_for filename, only_path: false
    end
  end

  def articles_matching(query, args = {})
    Article.search(query, args)
  end

  def per_page(format)
    return limit_article_display if format.nil? || format == "html"

    limit_rss_display
  end

  def rss_limit_params
    limit = limit_rss_display.to_i
    if limit.zero?
      {}
    else
      { limit: limit }
    end
  end

  def permalink_has_identifier
    unless /(%title%)/.match?(permalink_format)
      errors.add(:base, I18n.t("errors.permalink_need_a_title"))
    end

    if /\.(atom|rss)$/.match?(permalink_format)
      errors.add(:permalink_format, I18n.t("errors.cant_end_with_rss_or_atom"))
    end
  end

  def root_path
    split_base_url[:root_path]
  end

  def text_filter_object
    TextFilter.find_or_default(text_filter)
  end

  def has_twitter_configured?
    return false if twitter_consumer_key.nil? || twitter_consumer_secret.nil?
    return false if twitter_consumer_key.empty? || twitter_consumer_secret.empty?

    true
  end

  def allow_signup?
    allow_signup == 1
  end

  def shortener_url
    custom_url_shortener.present? ? custom_url_shortener : base_url
  end

  private

  def host_with_port
    split_base_url[:host_with_port]
  end

  def split_base_url
    unless @split_base_url
      raise "Invalid base_url: #{base_url}" unless base_url =~ %r{(https?)://([^/]*)(.*)}

      @split_base_url = { protocol: Regexp.last_match[1],
                          host_with_port: Regexp.last_match[2],
                          root_path: Regexp.last_match[3].gsub(%r{/$}, "") }
    end
    @split_base_url
  end
end
