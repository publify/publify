require_dependency 'spam_protection'
require 'sanitize'
require 'timeout'

class Comment < Feedback
  belongs_to :article

  content_fields :body

  belongs_to :user

  validates_presence_of :author, :body

  def notify_user_via_email(controller, user)
    if user.notify_via_email?
      EmailNotify.send_comment(controller, self, user)
    end
  end

  def notify_user_via_jabber(controller, user)
    if user.notify_via_jabber?
      JabberNotify.send_message(user, "New comment", "A new comment was posted to '#{article.title}' on #{blog.blog_name} by #{author}: #{body}", self.body_html)
    end
  end

  def interested_users
    users = User.find_boolean(:all, :notify_on_comments)
    self.notify_users = users
    users
  end

  protected

  def article_allows_feedback?
    return true if article.allow_comments?
    errors.add(:article, "Article is not open to comments")
    false
  end

  def body_html_postprocess(value, controller)
    sanitize(controller.send(:auto_link, value),'a href, b, br, i, p, em, strong, pre, code, ol, ul, li')
  end

  def default_text_filter_config_key
    'comment_text_filter'
  end

  def make_nofollow
    self.author    = author.nofollowify
    self.body_html = body_html.to_s.nofollowify
  end

  def originator
    author
  end
end
