require_dependency 'spam_protection'
class Feedback < ActiveRecord::Base
  self.table_name = "feedback"

  belongs_to :text_filter
  belongs_to :article

  include TypoGuid

  include Stateful
  include ContentBase

  after_save :invalidates_cache?
  after_destroy lambda { |c|  c.invalidates_cache?(true) }

  validate :feedback_not_closed, :on => :create

  before_create :create_guid, :article_allows_this_feedback
  before_save :correct_url
  after_save :post_trigger
  after_save :report_classification

  scope :ham, where("state in ('presumed_ham', 'ham')")
  scope :published_since, lambda {|time| ham.where('published_at > ?', time)}

  has_state(:state,
            :valid_states => [:unclassified, #initial state
                              :presumed_spam, :just_marked_as_spam, :spam,
                              :just_presumed_ham, :presumed_ham, :just_marked_as_ham, :ham],
            :handles => [:published?, :status_confirmed?, :just_published?,
                         :mark_as_ham, :mark_as_spam, :confirm_classification,
                         :withdraw,
                         :before_save_handler, :after_initialize_handler,
                         :send_notifications, :post_trigger, :report_classification])

  before_save :before_save_handler
  after_initialize :after_initialize_handler

  include States

  def self.default_order
    'created_at ASC'
  end

  def parent
    article
  end

  def permalink_url(anchor=:ignored, only_path=false)
    article.permalink_url("#{self.class.to_s.downcase}-#{id}",only_path)
  end

  def html_postprocess(field, html)
    helper = ContentTextHelpers.new
    helper.sanitize(helper.auto_link(html)).nofollowify
  end

  def correct_url
    return if url.blank?
    self.url = "http://" + url.to_s unless url =~ %r{^https?://}
  end

  def article_allows_this_feedback
    article && blog_allows_feedback? && article_allows_feedback?
  end

  def blog_allows_feedback?
    true
  end

  def akismet_options
    {:comment_type => self.class.to_s.downcase,
      :comment_author => originator,
      :comment_author_email => email,
      :comment_author_url => url,
      :comment_content => body}
  end

  def spam_fields
    [:title, :body, :ip, :url]
  end

  def classify
    begin
      return :ham if self.user_id
      return :spam if blog.default_moderate_comments
      return :ham unless blog.sp_global
    rescue NoMethodError
    end

    # Yeah, three state logic is evil...
    case sp_is_spam? || akismet_is_spam?
    when nil; :spam
    when true; :spam
    when false; :ham
    end
  end

  def sp_is_spam?(options={})
    sp = SpamProtection.new(blog)
    Timeout.timeout(defined?($TESTING) ? 10 : 30) do
      spam_fields.any? do |field|
        sp.is_spam?(self.send(field))
      end
    end
  rescue Timeout::Error
    nil
  end

  def akismet_is_spam?(options={})
    return false if akismet.nil?

    begin
      Timeout.timeout(defined?($TESTING) ? 30 : 60) do
        akismet.comment_check(ip, user_agent, akismet_options)
      end
    rescue Timeout::Error
      nil
    end
  end

  def change_state!
    result = ''
    if state.spam? || state.presumed_spam?
      mark_as_ham
      result = 'ham'
    else
      mark_as_spam
      result = 'spam'
    end
    save!
    result
  end

  def mark_as_ham!
    mark_as_ham
    save!
  end

  def mark_as_spam!
    mark_as_ham
    save!
  end

  def report_as_spam
    report_as('spam')
  end

  def report_as_ham
    report_as('ham')
  end

  def report_as spam_or_ham
    return if akismet.nil?
    begin
      Timeout.timeout(defined?($TESTING) ? 5 : 3600) {
        akismet.send("submit_#{spam_or_ham}",
                     ip, user_agent, akismet_options)
      }
    rescue Timeout::Error
      nil
    end
  end

  def withdraw!
    withdraw
    self.save!
  end

  def confirm_classification!
    confirm_classification
    self.save
  end

  def feedback_not_closed
    if article.comments_closed?
      errors.add(:article_id, 'Comment are closed')
    end
  end

  private
  @@akismet = nil

  def akismet
    @@akismet = akismet_client if @@akismet.nil?
    return @@akismet == false ? nil : @@akismet
  end

  def akismet_client
    return false if blog.sp_akismet_key.blank?

    client = Akismet::Client.new(blog.sp_akismet_key, blog.base_url)

    return client.verify_key ? client : false
  end
end
