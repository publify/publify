# coding: utf-8
require 'uri'
require 'net/http'

class Article < Content
  include TypoGuid
  include ConfigManager

  serialize :settings, Hash

  content_fields :body, :extended

  validates_uniqueness_of :guid
  validates_presence_of :title

  belongs_to :user

  has_many :pings,      :dependent => :destroy, :order => "created_at ASC"
  has_many :trackbacks, :dependent => :destroy, :order => "created_at ASC"
  has_many :feedback, :order => "created_at DESC"
  has_many :resources, :order => "created_at DESC", :dependent => :nullify
  has_many :categorizations
  has_many :categories, :through => :categorizations
  has_many :triggers, :as => :pending_item

  has_many :comments,   :dependent => :destroy, :order => "created_at ASC" do

    # Get only ham or presumed_ham comments
    def ham
      find :all, :conditions => {:state => ["presumed_ham", "ham"]}
    end

    # Get only spam or presumed_spam comments
    def spam
      find :all, :conditions => {:state => ["presumed_spam", "spam"]}
    end

  end

  with_options(:conditions => { :published => true }, :order => 'created_at DESC') do |this|
    this.has_many :published_comments,   :class_name => "Comment", :order => "created_at ASC"
    this.has_many :published_trackbacks, :class_name => "Trackback", :order => "created_at ASC"
    this.has_many :published_feedback,   :class_name => "Feedback", :order => "created_at ASC"
  end

  has_and_belongs_to_many :tags

  before_create :set_defaults, :create_guid
  after_create :add_notifications
  before_save :set_published_at, :ensure_settings_type, :set_permalink
  after_save :post_trigger, :keywords_to_tags, :shorten_url

  scope :category, lambda {|category_id| {:conditions => ['categorizations.category_id = ?', category_id], :include => 'categorizations'}}
  scope :drafts, lambda { { :conditions => { :state => 'draft' }, :order => 'created_at DESC' } }
  scope :without_parent, {:conditions => {:parent_id => nil}}
  scope :child_of, lambda { |article_id| {:conditions => {:parent_id => article_id}} }
  scope :published, lambda { { :conditions => { :published => true, :published_at => Time.at(0)..Time.now }, :order => 'published_at DESC' } }
  scope :pending, lambda { { :conditions => ['state = ? and published_at > ?', 'publication_pending', Time.now], :order => 'published_at DESC' } }
  scope :withdrawn, lambda { { :conditions => { :state => 'withdrawn' }, :order => 'published_at DESC' } }
  scope :published_at, lambda {|time_params| { :conditions => { :published => true, :published_at => Article.time_delta(*time_params) }, :order => 'published_at DESC' } }

  setting :password,                   :string, ''

  def initialize(*args)
    super
    # Yes, this is weird - PDC
    begin
      self.settings ||= {}
    rescue Exception => e
      self.settings = {}
    end
  end

  def set_permalink
    return if self.state == 'draft'
    self.permalink = self.title.to_permalink if self.permalink.nil? or self.permalink.empty?
  end

  def has_child?
    Article.exists?({:parent_id => self.id})
  end

  attr_accessor :draft, :keywords

  has_state(:state,
            :valid_states  => [:new, :draft,
                               :publication_pending, :just_published, :published,
                               :just_withdrawn, :withdrawn],
            :initial_state =>  :new,
            :handles       => [:withdraw,
                               :post_trigger,
                               :send_pings, :send_notifications,
                               :published_at=, :just_published?])

  include Article::States

  class << self
    def last_draft(article_id)
      article = Article.find(article_id)
      while article.has_child?
        article = Article.child_of(article.id).first
      end
      article
    end

    def search_with_pagination(search_hash, paginate_hash)
      
      state = (search_hash[:state] and ["no_draft", "drafts", "published", "withdrawn", "pending"].include? search_hash[:state]) ? search_hash[:state] : 'no_draft'
      
      
      list_function  = ["Article.#{state}"] + function_search_no_draft(search_hash)

      if search_hash[:category] and search_hash[:category].to_i > 0
        list_function << 'category(search_hash[:category])'
      end

      list_function << "page(paginate_hash[:page])"
      list_function << "per(paginate_hash[:per_page])"

      eval(list_function.join('.'))
    end

  end

  def year_url
    published_at.year.to_s
  end

  def month_url
    sprintf("%.2d", published_at.month)
  end

  def day_url
    sprintf("%.2d", published_at.day)
  end

  def title_url
    URI.encode(permalink.to_s)
  end

  def permalink_url_options(nesting = false)
    format_url = blog.permalink_format.dup
    format_url.gsub!('%year%', year_url)
    format_url.gsub!('%month%', month_url)
    format_url.gsub!('%day%', day_url)
    format_url.gsub!('%title%', title_url)
    if format_url[0,1] == '/'
      format_url[1..-1]
    else
      format_url
    end
  end

  def permalink_url(anchor=nil, only_path=false)
    @cached_permalink_url ||= {}

    @cached_permalink_url["#{anchor}#{only_path}"] ||= \
      blog.url_for(permalink_url_options, :anchor => anchor, :only_path => only_path)
  end

  def param_array
    @param_array ||=
      [published_at.year,
                 sprintf('%.2d', published_at.month),
                 sprintf('%.2d', published_at.day),
                 permalink].tap \
      do |params|
        this = self
        k = class << params; self; end
        k.send(:define_method, :to_s) { params[-1] }
      end
  end

  def to_param
    param_array
  end

  def trackback_url
    blog.url_for("trackbacks?article_id=#{self.id}", :only_path => false)
  end

  def permalink_by_format(format=nil)
    if format.nil?
      permalink_url
    elsif format.to_sym == :rss
      feed_url(:rss)
    elsif format.to_sym == :atom
      feed_url(:atom)
    else
      raise UnSupportedFormat
    end
  end

  def comment_url
    blog.url_for("comments?article_id=#{self.id}", :only_path => false)
  end

  def preview_comment_url
    blog.url_for("comments/preview?article_id=#{self.id}", :only_path => false)
  end

  def feed_url(format = :rss20)
    format_extension = format.to_s.gsub(/\d/,'')
    permalink_url + ".#{format_extension}"
  end

  def edit_url
    blog.url_for(:controller => "/admin/content", :action =>"edit", :id => id)
  end

  def delete_url
    blog.url_for(:controller => "/admin/content", :action =>"destroy", :id => id)
  end

  def html_urls
    urls = Array.new
    html.gsub(/<a\s+[^>]*>/) do |tag|
      if(tag =~ /\bhref=(["']?)([^ >"]+)\1/)
        urls.push($2.strip)
      end
    end

    urls.uniq
  end

  def really_send_pings(serverurl = blog.base_url, articleurl = nil)
    return unless blog.send_outbound_pings

    articleurl ||= permalink_url(nil)

    weblogupdatesping_urls = blog.ping_urls.gsub(/ +/,'').split(/[\n\r]+/).map(&:strip)
    pingback_or_trackback_urls = self.html_urls

    ping_urls = weblogupdatesping_urls + pingback_or_trackback_urls

    existing_ping_urls = pings.collect { |p| p.url }

    ping_urls.uniq.each do |url|
      begin
        unless existing_ping_urls.include?(url)
          ping = pings.build("url" => url)

          if weblogupdatesping_urls.include?(url)
            ping.send_weblogupdatesping(serverurl, articleurl)
          elsif pingback_or_trackback_urls.include?(url)
            ping.send_pingback_or_trackback(articleurl)
          end
        end
      rescue Exception => e
        logger.error(e)
        # in case the remote server doesn't respond or gives an error,
        # we should throw an xmlrpc error here.
      end
    end
  end

  def next
    self.class.find(:first, :conditions => ['published_at > ?', published_at],
                    :order => 'published_at asc')
  end

  def previous
    self.class.find(:first, :conditions => ['published_at < ?', published_at],
                    :order => 'published_at desc')
  end

  # Count articles on a certain date
  def self.count_by_date(year, month = nil, day = nil, limit = nil)
    if !year.blank?
      count(:conditions => { :published_at => time_delta(year, month, day),
              :published => true })
    else
      count(:conditions => { :published => true })
    end
  end

  def self.find_by_published_at
    super(:published_at)
  end

  def self.get_or_build_article id = nil
    return Article.find(id) if id
    article = Article.new.tap do |art|
      art.allow_comments = art.blog.default_allow_comments
      art.allow_pings = art.blog.default_allow_pings
      art.text_filter = art.blog.text_filter
      art.old_permalink = art.permalink_url unless art.permalink.nil? or art.permalink.empty?
      art.published = true
    end
  end

  # Finds one article which was posted on a certain date and matches the supplied dashed-title
  # params is a Hash
  def self.find_by_permalink(params)
    date_range = self.time_delta(params[:year], params[:month], params[:day])

    req_params = {}
    req_params[:permalink] = params[:title] if params[:title]
    req_params[:published_at] = date_range if date_range

    return nil if req_params.empty? # no search if no params send

    article = find_published(:first, :conditions => req_params)
    return article if article

    if params[:title]
      req_params[:permalink] = CGI.escape(params[:title])
      article = find_published(:first, :conditions => req_params)
      return article if article
    end

    raise ActiveRecord::RecordNotFound
  end

  def self.find_by_params_hash(params = {})
    params[:title] ||= params[:article_id]
    find_by_permalink(params)
  end

  # Fulltext searches the body of published articles
  def self.search(query, args={})
    query_s = query.to_s.strip
    if !query_s.empty? && args.empty?
      Article.searchstring(query)
    elsif !query_s.empty? && !args.empty?
      Article.searchstring(query).page(args[:page]).per(args[:per])
    else
      []
    end
  end

  def keywords_to_tags
    Article.transaction do
      tags.clear
      tags <<
      keywords.to_s.scan(/((['"]).*?\2|[\.\w]+)/).collect do |x|
        x.first.tr("\"'", '')
      end.uniq.map do |tagword|
        Tag.get(tagword)
      end
    end
  end

  def interested_users
    User.find_all_by_notify_on_new_articles(true)
  end

  def notify_user_via_email(user)
    if user.notify_via_email?
      EmailNotify.send_article(self, user)
    end
  end

  def comments_closed?
    !(allow_comments? && in_feedback_window?)
  end

  def pings_closed?
    !(allow_pings? && in_feedback_window?)
  end

  # check if time to comment is open or not
  def in_feedback_window?
    self.blog.sp_article_auto_close.zero? ||
      self.published_at.to_i > self.blog.sp_article_auto_close.days.ago.to_i
  end

  def cast_to_boolean(value)
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)
  end
  # Cast the input value for published= before passing it to the state.
  def published=(newval)
    state.published = cast_to_boolean(newval)
  end

  def content_fields
    [:body, :extended]
  end

  # The web interface no longer distinguishes between separate "body" and
  # "extended" fields, and instead edits everything in a single edit field,
  # separating the extended content using "\<!--more-->".
  def body_and_extended
    if extended.nil? || extended.empty?
      body
    else
      body + "\n<!--more-->\n" + extended
    end
  end

  # Split apart value around a "\<!--more-->" comment and assign it to our
  # #body and #extended fields.
  def body_and_extended= value
    parts = value.split(/\n?<!--more-->\n?/, 2)
    self.body = parts[0]
    self.extended = parts[1] || ''
  end

  def link_to_author?
    !user.email.blank? && blog.link_to_author
  end

  def password_protected?
    not password.blank?
  end

  def add_comment(params)
    comments.build(params)
  end

  def add_category(category, is_primary = false)
    self.categorizations.build(:category => category, :is_primary => is_primary)
  end

  def access_by?(user)
    user.admin? || user_id == user.id
  end

  protected

  def set_published_at
    if self.published and self[:published_at].nil?
      self[:published_at] = self.created_at || Time.now
    end
  end

  def ensure_settings_type
    if settings.is_a?(String)
      # Any dump access forcing de-serialization
      password.blank?
    end
  end

  def set_defaults
    if self.attributes.include?("permalink") and
      (self.permalink.blank? or
       self.permalink.to_s =~ /article-draft/ or
       self.state == "draft"
      )
      set_permalink
    end
    if blog && self.allow_comments.nil?
      self.allow_comments = blog.default_allow_comments
    end

    if blog && self.allow_pings.nil?
      self.allow_pings = blog.default_allow_pings
    end

    true
  end

  def add_notifications
    users = interested_users
    users << self.user if (self.user.notify_watch_my_articles? rescue false)
    self.notify_users = users.uniq
  end

  def self.time_delta(year = nil, month = nil, day = nil)
    return nil if year.nil? && month.nil? && day.nil?
    from = Time.utc(year, month || 1, day || 1)

    to = from.next_year
    to = from.next_month unless month.blank?
    to = from + 1.day unless day.blank?
    to = to - 1 # pull off 1 second so we don't overlap onto the next day
    return from..to
  end
end
