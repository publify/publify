class Feedback < Content
  # Empty, for now, ready to hoist up methods from Comment & Trackback
  include TypoGuid
  validates_age_of :article_id

  def self.default_order
    'created_at ASC'
  end

  def location(anchor=:ignored, only_path=true)
    blog.url_for(article, "#{self.class.to_s.downcase}-#{id}", only_path)
  end

  before_create :create_guid, :make_nofollow, :article_allows_this_feedback
  before_save :correct_url

  def correct_url
    if !url.blank? && url !~ /^http:\/\//
      self.url = 'http://' + url
    end
  end

  def article_allows_this_feedback
    return if !article || blog_is_closed_to_feedback? || article_denies_feedback?
  end

  def blog_is_closed_to_feedback?
    false
  end
end
