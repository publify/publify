require_dependency 'spam_protection'
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

  def interested_users
    users = User.find_boolean(:all, :notify_on_comments)
    self.notify_users = users
    users
  end

  def default_text_filter
    blog.comment_text_filter.to_text_filter
  end

  def atom_author(xml)
    xml.author { xml.name author }
  end

  def rss_author(xml)
  end

  def atom_title(xml)
    xml.title "Comment on #{article.title} by #{author}", :type => 'html'
  end

  def rss_title(xml)
    xml.title "Comment on #{article.title} by #{author}"
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
