# frozen_string_literal: true

# Legacy class to support old feedback sent as trackbacks.
class Trackback < Feedback
  content_fields :excerpt
  validates :title, :excerpt, :url, presence: true

  before_create :process_trackback

  def process_trackback
    if excerpt.length >= 251
      # this limits excerpt to 250 chars, including the trailing "..."
      self.excerpt = excerpt[0..246] << "..."
    end
  end

  def article_allows_feedback?
    return true if article.allow_pings?

    errors.add(:article, "Article is not pingable")
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

  def feed_title
    "Trackback from #{blog_name}: #{title} on #{article.title}"
  end
end
