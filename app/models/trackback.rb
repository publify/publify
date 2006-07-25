require_dependency 'spam_protection'

class Trackback < Feedback
  belongs_to :article, :counter_cache => true

  content_fields :excerpt

  validates_presence_of :title, :excerpt, :url

  def initialize(*args, &block)
    super(*args, &block)
    self.title ||= self.url
    self.blog_name ||= ""
  end

  protected
  before_create :process_trackback

  def make_nofollow
    self.blog_name = blog_name.strip_html
    self.title     = title.strip_html
    self.excerpt   = excerpt.strip_html
  end

  def process_trackback
    if excerpt.length >= 251
      # this limits excerpt to 250 chars, including the trailing "..."
      self.excerpt = excerpt[0..246] << "..."
    end
  end

  def article_denies_feedback?
    return false if article.allow_pings?
    errors.add(:article, 'Article is not pingable')
  end

  def blog_is_closed_to_feedback?
    return false unless blog.global_pings_disable
    errors.add(:article, "Pings are disabled")
  end

  def akismet_options
    {:user_ip => ip, :comment_type => 'trackback', :comment_author => blog_name, :comment_author_email => nil,
      :comment_author_url => url, :comment_content => excerpt}
  end

  def spam_fields
    [:title, :excerpt, :ip, :url]
  end
end

