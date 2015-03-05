require_dependency 'spam_protection'
require 'timeout'

class Comment < Feedback
  belongs_to :user
  content_fields :body
  validates :author, :body, presence: true

  attr_accessor :referrer, :permalink

  scope :spam, -> { where(state: 'spam') }
  scope :not_spam, -> { where("state != 'spam'") }
  scope :presumed_spam, -> { where(state: 'presumed_spam') }
  scope :presumed_ham, -> { where(state: 'presumed_ham') }
  scope :ham, -> { where(state: 'ham') }
  scope :unconfirmed, -> { where('state in (?, ?)', 'presumed_spam', 'presumed_ham') }
  scope :last_published, -> { where(published: true).limit(5).order('created_at DESC') }

  def notify_user_via_email(user)
    EmailNotify.send_comment(self, user) if user.notify_via_email?
  end

  def interested_users
    User.where(notify_on_comments: true)
  end

  def default_text_filter
    blog.comment_text_filter.to_text_filter
  end

  def feed_title
    "Comment on #{article.title} by #{author}"
  end

  protected

  def article_allows_feedback?
    return true if article.allow_comments?
    errors.add(:article, 'Article is not open to comments')
    false
  end

  def originator
    author
  end

  def content_fields
    [:body]
  end
end
