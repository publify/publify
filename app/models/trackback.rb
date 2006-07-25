require_dependency 'spam_protection'

class Trackback < Feedback
  belongs_to :article

  content_fields :excerpt

  validates_presence_of :title, :excerpt, :url

  def initialize(*args, &block)
    super(*args, &block)
    self.title ||= self.url
    self.blog_name ||= ""
  end

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

  def article_allows_feedback?
    return true if article.allow_pings?
    errors.add(:article, 'Article is not pingable')
    false
  end

  def blog_allows_feedback?
    return true unless blog.global_pings_disable
    errors.add(:article, "Pings are disabled")
    false
  end

  def originator
    blog_name
  end

  def body
    excerpt
  end

  def body=(newval)
    self.excerpt = newval
  end
end

