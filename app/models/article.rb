# coding: utf-8
require 'uri'
require 'net/http'

class Article < Content
  include PublifyGuid
  include ConfigManager

  serialize :settings, Hash

  content_fields :body, :extended

  validates_uniqueness_of :guid
  validates_presence_of :title

  has_many :pings, dependent: :destroy, order: "created_at ASC"
  has_many :trackbacks, dependent: :destroy, order: "created_at ASC"
  has_many :feedback, order: "created_at DESC"
  has_many :resources, order: "created_at DESC", dependent: :nullify
  has_many :triggers, as: :pending_item
  has_many :comments, dependent: :destroy, order: "created_at ASC" do
    # Get only ham or presumed_ham comments
    def ham
      where(state: ["presumed_ham", "ham"])
    end

    # Get only spam or presumed_spam comments
    def spam
      where(state: ["presumed_spam", "spam"])
    end
  end

  with_options(:conditions => { :published => true }, :order => 'created_at ASC') do |this|
    this.has_many :published_comments, class_name: "Comment"
    this.has_many :published_trackbacks, class_name: "Trackback"
    this.has_many :published_feedback, class_name: "Feedback"
  end

  has_and_belongs_to_many :tags

  before_create :create_guid
  before_save :set_published_at, :ensure_settings_type, :set_permalink
  after_save :post_trigger, :keywords_to_tags, :shorten_url

  scope :drafts, lambda { where(state: 'draft').order('created_at DESC') }
  scope :child_of, lambda { |article_id| where(parent_id: article_id) }
  scope :published_at, lambda {|time_params| published.where(published_at: PublifyTime.delta(*time_params)).order('published_at DESC')}
  scope :published_since, lambda {|time| published.where('published_at > ?', time).order('published_at DESC') }
  scope :withdrawn, lambda { where(state: 'withdrawn').order('published_at DESC') }
  scope :pending, lambda { where('state = ? and published_at > ?', 'publication_pending', Time.now).order('published_at DESC') }

  scope :bestof, ->() {
    joins(:feedback).
      where('feedback.published' => true, 'feedback.type' => 'Comment',
            'contents.published' => true).
      group('contents.id').
      order('count(feedback.id) DESC').
      select('contents.*, count(feedback.id) as comment_count').
      limit(5)
  }

  setting :password, :string, ''

  attr_accessor :draft, :keywords

  include Article::States

  has_state(:state, :valid_states  => [:new, :draft,
                                       :publication_pending, :just_published, :published,
                                       :just_withdrawn, :withdrawn],
                                       :initial_state =>  :new,
                                       :handles       => [:withdraw,
                                                          :post_trigger,
                                                          :send_pings, :send_notifications,
                                                          :published_at=, :just_published?])

  def initialize(*args)
    super
    # Yes, this is weird - PDC
    begin
      self.settings ||= {}
    rescue
      self.settings = {}
    end
  end

  def set_permalink
    return if self.state == 'draft' || self.permalink.present?
    self.permalink = self.title.to_permalink
  end

  def has_child?
    Article.exists?(parent_id: self.id)
  end

  def post_type
    _post_type = read_attribute(:post_type)
    _post_type = 'read' if _post_type.blank?
    _post_type
  end

  def self.last_draft(article_id)
    article = Article.find(article_id)
    while article.has_child?
      article = Article.child_of(article.id).first
    end
    article
  end

  def self.search_with(params)
    params ||= {}
    scoped = super(params)
    if ["no_draft", "drafts", "published", "withdrawn", "pending"].include?(params[:state])
      scoped = scoped.send(params[:state])
    end

    scoped.order('created_at DESC')
  end

  def permalink_url(anchor=nil, only_path=false)
    @cached_permalink_url ||= {}
    @cached_permalink_url["#{anchor}#{only_path}"] ||= blog.url_for(permalink_url_options, anchor: anchor, only_path: only_path)
  end

  def save_attachments!(files)
    files ||= {}
    files.values.each { |f| self.save_attachment!(f) }
  end

  def save_attachment!(file)
    self.resources << Resource.create_and_upload(file)
  rescue => e
    logger.info(e.message)
  end

  def trackback_url
    blog.url_for("trackbacks?article_id=#{self.id}", :only_path => false)
  end

  def comment_url
    blog.url_for("comments?article_id=#{self.id}", only_path: true)
  end

  def preview_comment_url
    blog.url_for("comments/preview?article_id=#{self.id}", :only_path => true)
  end

  def feed_url(format)
    "#{permalink_url}.#{format.gsub(/\d/,'')}"
  end

  def really_send_pings
    return unless blog.send_outbound_pings

    blog.urls_to_ping_for(self).each do |url_to_ping|
      begin
        url_to_ping.send_weblogupdatesping(blog.base_url, permalink_url)
      rescue Exception => e
        logger.error(e)
        # in case the remote server doesn't respond or gives an error,
        # we should throw an xmlrpc error here.
      end
    end

    html_urls_to_ping.each do |url_to_ping|
      begin
        url_to_ping.send_pingback_or_trackback(permalink_url)
      rescue Exception => exception
        logger.error(exception)
        # in case the remote server doesn't respond or gives an error,
        # we should throw an xmlrpc error here.
      end
    end
  end

  def next
    Article.where('published_at > ?', published_at).order('published_at asc').limit(1).first
  end

  def previous
    Article.where('published_at < ?', published_at).order('published_at desc').limit(1).first
  end

  def self.find_by_published_at
    result = select('published_at').where('published_at is not NULL').where(type: 'Article')
    result.map{ |d| [d.published_at.strftime('%Y-%m')]}.uniq
  end

  # Finds one article which was posted on a certain date and matches the supplied dashed-title
  # params is a Hash
  def self.find_by_permalink(params)
    date_range = PublifyTime.delta(params[:year], params[:month], params[:day])

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
    Tag.create_from_article!(self)
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

  def html_urls
    urls = Array.new
    html.gsub(/<a\s+[^>]*>/) do |tag|
      if(tag =~ /\bhref=(["']?)([^ >"]+)\1/)
        urls.push($2.strip)
      end
    end
    urls.uniq
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

  def password_protected?
    not password.blank?
  end

  def add_comment(params)
    comments.build(params)
  end

  def access_by?(user)
    user.admin? || user_id == user.id
  end

  def already_ping?(url)
    self.pings.map(&:url).include?(url)
  end

  def allow_comments?
    return self.allow_comments unless self.allow_comments.nil?
    blog.default_allow_comments
  end

  def allow_pings?
    return self.allow_pings unless self.allow_pings.nil?
    blog.default_allow_pings
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

  private

  def permalink_url_options
    format_url = blog.permalink_format.dup
    format_url.gsub!('%year%', published_at.year.to_s)
    format_url.gsub!('%month%', sprintf("%.2d", published_at.month))
    format_url.gsub!('%day%', sprintf("%.2d", published_at.day))
    format_url.gsub!('%title%', URI.encode(permalink.to_s))
    if format_url[0,1] == '/'
      format_url[1..-1]
    else
      format_url
    end
  end


  def html_urls_to_ping
    urls_to_ping = []
    html_urls.delete_if{|url| already_ping?(url)}.uniq.each do |url_to_ping|
      urls_to_ping << self.pings.build("url" => url_to_ping)
    end
    urls_to_ping
  end
end
