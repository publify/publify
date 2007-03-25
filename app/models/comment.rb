require_dependency 'spam_protection'
require 'sanitize'
require 'timeout'

class Comment < Feedback
  belongs_to :article
  belongs_to :user
  content_fields :body
  validates_presence_of :author, :body

  attr_accessor :user_agent
  attr_accessor :referrer
  attr_accessor :permalink

  def notify_user_via_email(user)
    if user.notify_via_email?
      EmailNotify.send_comment(self, user)
    end
  end

  def notify_user_via_jabber(user)
    if user.notify_via_jabber?
      JabberNotify.send_message(user, "New comment", "A new comment was posted to '#{article.title}' on #{blog.blog_name} by #{author}: 
        #{body}", self.html(:body)) 
    end
  end

  def interested_users
    users = User.find_boolean(:all, :notify_on_comments)
    self.notify_users = users
    users
  end

  def default_text_filter
    blog.comment_text_filter.to_text_filter
  end

  protected

  def article_allows_feedback?
    return true if article.allow_comments?
    errors.add(:article, "Article is not open to comments")
    false
  end

  def originator
    author
  end

  def additional_akismet_options
    { :user_agent => user_agent,
      :referrer   => referrer,
      :permalink  => permalink }
  end

  def self.html_map(field=nil)
    html_map = { :body => true }
    if field
      html_map[field.to_sym]
    else
      html_map
    end
  end

  def content_fields
    [:body]
  end
end
