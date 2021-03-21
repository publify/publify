# frozen_string_literal: true

require "aasm"
require "uri"
require "net/http"

class Article < Content
  include PublifyGuid
  include ConfigManager

  serialize :settings, Hash

  content_fields :body, :extended

  validates :guid, uniqueness: true
  validates :title, presence: true

  has_many :pings, dependent: :destroy
  has_many :trackbacks, dependent: :destroy
  has_many :feedback
  has_many :triggers, as: :pending_item
  has_many :comments, dependent: :destroy

  before_save :set_permalink
  before_create :create_guid
  after_save :keywords_to_tags, :shorten_url

  scope :child_of, ->(article_id) { where(parent_id: article_id) }
  scope :published_since, ->(time) { published.where("published_at > ?", time) }
  scope :withdrawn, -> { where(state: "withdrawn").order(default_order) }
  scope :pending, -> { where(state: "publication_pending").order(default_order) }

  scope :bestof, lambda {
    joins(:feedback).
      where("feedback.type" => "Comment",
            "contents.state" => "published").
      group("contents.id").
      select("contents.*, count(feedback.id) as comment_count").
      order("comment_count DESC").
      limit(5)
  }

  setting :password, :string, ""

  attr_accessor :draft, :keywords

  include AASM

  aasm column: :state do
    state :draft, initial: true
    # TODO: Disallow if published_at in past
    state :publication_pending, after_enter: :trigger_publication
    state :published, after_enter: :really_send_notifications
    state :withdrawn

    event :withdraw do
      transitions from: :published, to: :withdrawn
      transitions from: :publication_pending, to: :draft
    end

    event :publish do
      before do
        self.published_at ||= Time.zone.now
      end

      transitions from: [:new, :draft], to: :publication_pending do
        guard do
          published_at > Time.zone.now
        end
      end

      transitions from: [:new, :draft, :publication_pending], to: :published do
        guard do
          published_at <= Time.zone.now
        end
      end
    end
  end

  def set_permalink
    return if draft? || permalink.present?

    self.permalink = title.to_permalink
  end

  def has_child?
    Article.exists?(parent_id: id)
  end

  def post_type
    post_type = self[:post_type]
    post_type = "read" if post_type.blank?
    post_type
  end

  def self.last_draft(article_id)
    article = Article.find(article_id)
    article = Article.child_of(article.id).first while article.has_child?
    article
  end

  def self.search_with(params)
    params ||= {}
    scoped = super(params)
    if %w(no_draft drafts published withdrawn pending).include?(params[:state])
      scoped = scoped.send(params[:state])
    end

    scoped.order("created_at DESC")
  end

  # FIXME: Use keyword params to clean up call sites.
  def permalink_url(anchor = nil, only_path = false)
    return unless published?

    @cached_permalink_url ||= {}
    @cached_permalink_url["#{anchor}#{only_path}"] ||=
      blog.url_for(permalink_url_options, anchor: anchor, only_path: only_path)
  end

  def save_attachments!(files)
    files ||= {}
    files.each_value { |f| save_attachment!(f) }
  end

  def save_attachment!(file)
    resources.create!(upload: file, blog: blog)
  end

  def comment_url
    blog.url_for("comments?article_id=#{id}", only_path: true)
  end

  def preview_comment_url
    blog.url_for("comments/preview?article_id=#{id}", only_path: true)
  end

  def feed_url(format)
    "#{permalink_url}.#{format.gsub(/\d/, "")}"
  end

  def next
    Article.where("published_at > ?", published_at).order("published_at asc").
      limit(1).first
  end

  def previous
    Article.where("published_at < ?", published_at).order("published_at desc").
      limit(1).first
  end

  def publication_month
    published_at.strftime("%Y-%m")
  end

  def self.publication_months
    result = select("published_at").where("published_at is not NULL").where(type: "Article")
    result.map { |it| [it.publication_month] }.uniq
  end

  # Finds one article which was posted on a certain date and matches the
  # supplied dashed-title params is a Hash
  def self.requested_article(params)
    date_range = PublifyTime.delta(params[:year], params[:month], params[:day])

    req_params = {}
    req_params[:permalink] = params[:title] if params[:title]
    req_params[:published_at] = date_range if date_range

    return if req_params.empty? # no search if no params send

    article = published.find_by(req_params)
    return article if article

    if params[:title]
      req_params[:permalink] = CGI.escape(params[:title])
      article = published.find_by(req_params)
      return article if article
    end
  end

  # Fulltext searches the body of published articles
  def self.search(query, args = {})
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
    User.where(notify_on_new_articles: true)
  end

  def notify_user_via_email(user)
    EmailNotify.send_article(self, user) if user.notify_via_email?
  end

  def comments_closed?
    !(allow_comments? && in_feedback_window?)
  end

  def html_urls
    urls = []
    html.gsub(/<a\s+[^>]*>/) do |tag|
      urls.push(Regexp.last_match[2].strip) if tag =~ /\bhref=(["']?)([^ >"]+)\1/
    end
    urls.uniq
  end

  def pings_closed?
    !(allow_pings? && in_feedback_window?)
  end

  # check if time to comment is open or not
  def in_feedback_window?
    blog.sp_article_auto_close.zero? ||
      published_at.to_i > blog.sp_article_auto_close.days.ago.to_i
  end

  # The web interface no longer distinguishes between separate "body" and
  # "extended" fields, and instead edits everything in a single edit field,
  # separating the extended content using "\<!--more-->".
  def body_and_extended
    if extended.blank?
      body
    else
      "#{body}\n<!--more-->\n#{extended}"
    end
  end

  # Split apart value around a "\<!--more-->" comment and assign it to our
  # #body and #extended fields.
  def body_and_extended=(value)
    parts = value.split(/\n?<!--more-->\n?/, 2)
    self.body = parts[0]
    self.extended = parts[1] || ""
  end

  def password_protected?
    password.present?
  end

  def add_comment(params)
    comments.build(params)
  end

  def access_by?(user)
    user.admin? || user_id == user.id
  end

  def allow_comments?
    return allow_comments unless allow_comments.nil?

    blog.default_allow_comments
  end

  def allow_pings?
    return allow_pings unless allow_pings.nil?

    blog.default_allow_pings
  end

  def published_comments
    comments.published.oldest_first
  end

  def published_trackbacks
    trackbacks.published.oldest_first
  end

  def published_feedback
    feedback.published.oldest_first
  end

  private

  def permalink_url_options
    format_url = blog.permalink_format.dup
    format_url.gsub!("%year%", published_at.year.to_s)
    format_url.gsub!("%month%", sprintf("%<month>.2d", month: published_at.month))
    format_url.gsub!("%day%", sprintf("%<day>.2d", day: published_at.day))
    format_url.gsub!("%title%", URI::DEFAULT_PARSER.escape(permalink.to_s))
    if format_url[0, 1] == "/"
      format_url[1..-1]
    else
      format_url
    end
  end

  def trigger_publication
    # TODO: Skip if already published, update when published_at changes
    Trigger.post_action(published_at, self, "publish!")
  end
end
