# frozen_string_literal: true

require "aasm"
require "akismet"

class Feedback < ApplicationRecord
  self.table_name = "feedback"

  belongs_to :article, touch: true

  include PublifyGuid
  include ContentBase

  validate :article_allows_this_feedback, on: :create
  validate :feedback_not_closed, on: :create
  validates :article, presence: true

  before_save :correct_url, :classify_content
  before_create :create_guid

  # TODO: Rename so it doesn't sound like only approved ham
  scope :ham, -> { where(state: %w(presumed_ham ham)) }

  scope :spam, -> { where(state: "spam") }
  scope :created_since, ->(time) { ham.where("created_at > ?", time) }
  scope :presumed_ham, -> { where(state: "presumed_ham") }
  scope :presumed_spam, -> { where(state: "presumed_spam") }
  scope :unapproved, -> { where(state: ["presumed_spam", "presumed_ham"]) }

  scope :published, -> { ham }
  scope :oldest_first, -> { order(:created_at) }
  scope :newest_first, -> { order(created_at: :desc) }

  include AASM

  aasm column: :state do
    state :unclassified, initial: true
    state :presumed_ham
    state :presumed_spam
    state :spam, after_enter: [:send_notifications, :report_as_spam]
    state :ham, after_enter: [:send_notifications, :report_as_ham]

    event :presume_ham do
      transitions from: :unclassified, to: :ham, if: ->() { user_id.present? }
      transitions from: :unclassified, to: :presumed_ham
    end

    event :presume_spam do
      transitions from: :unclassified, to: :presumed_spam
    end

    event :mark_as_ham do
      transitions to: :ham
    end

    event :mark_as_spam do
      transitions to: :spam
    end

    event :withdraw do
      transitions from: [:presumed_ham, :ham], to: :spam
    end
  end

  # FIXME: Inline this method
  def self.paginated(page, per_page)
    page(page).per(per_page)
  end

  def self.allowed_tags
    @allowed_tags ||= Rails::Html::SafeListSanitizer.allowed_tags - ["img"]
  end

  def parent
    article
  end

  def classify_content
    return unless unclassified?

    case classify
    when :ham then presume_ham
    else presume_spam
    end
  end

  def permalink_url(_anchor = :ignored, only_path = false)
    article.permalink_url("#{self.class.to_s.downcase}-#{id}", only_path)
  end

  def html_postprocess(_field, html)
    helper = ContentTextHelpers.new
    helper.sanitize(helper.auto_link(html), tags: self.class.allowed_tags)
  end

  def correct_url
    return if url.blank?

    self.url = "http://#{url}" unless %r{^https?://}.match?(url)
  end

  def article_allows_this_feedback
    article && blog_allows_feedback? && article_allows_feedback?
  end

  def akismet_options
    { type: self.class.to_s.downcase,
      author: originator,
      author_email: email,
      author_url: url,
      text: body }
  end

  def spam_fields
    [:title, :body, :ip, :url]
  end

  def classify
    return :ham if user_id
    return :spam if blog.default_moderate_comments
    return :ham unless blog.sp_global

    # Yeah, three state logic is evil...
    case sp_is_spam? || akismet_is_spam?
    when nil then :spam
    when true then :spam
    when false then :ham
    end
  end

  def sp_is_spam?(_options = {})
    sp = SpamProtection.new(blog)
    Timeout.timeout(30) do
      spam_fields.any? do |field|
        sp.is_spam?(send(field))
      end
    end
  rescue Timeout::Error
    nil
  end

  def akismet_is_spam?(_options = {})
    return false if akismet.nil?

    begin
      Timeout.timeout(60) do
        akismet.comment_check(ip, user_agent, akismet_options)
      end
    rescue Timeout::Error
      nil
    end
  end

  def change_state!
    result = ""
    if spam? || presumed_spam?
      mark_as_ham!
      result = "ham"
    else
      mark_as_spam!
      result = "spam"
    end
    result
  end

  def confirm_classification!
    confirm_classification
    save!
  end

  def confirm_classification
    if presumed_spam?
      mark_as_spam
    elsif presumed_ham?
      mark_as_ham
    end
  end

  def report_as_spam
    return if akismet.nil?

    begin
      Timeout.timeout(5) do
        akismet.submit_spam(ip, user_agent, akismet_options)
      end
    rescue Timeout::Error
      nil
    end
  end

  def report_as_ham
    return if akismet.nil?

    begin
      Timeout.timeout(5) do
        akismet.ham(ip, user_agent, akismet_options)
      end
    rescue Timeout::Error
      nil
    end
  end

  def feedback_not_closed
    check_article_closed_for_feedback
  end

  def send_notifications
    nil
  end

  def published?
    ham? || presumed_ham?
  end

  def status_confirmed?
    ham? || spam?
  end

  def spammy?
    spam? || presumed_spam?
  end

  delegate :blog, to: :article

  private

  def akismet
    @akismet ||= akismet_client
  end

  def akismet_client
    return nil if blog.sp_akismet_key.blank?

    client = Akismet::Client.new(blog.sp_akismet_key, blog.base_url)
    begin
      client.verify_key ? client : nil
    rescue SocketError
      nil
    end
  end

  def blog_id
    article.blog_id if article.present?
  end
end
