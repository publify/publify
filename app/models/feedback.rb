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
    article && blog_allows_feedback? && article_allows_feedback?
  end

  def blog_allows_feedback?
    true
  end

  def akismet_options
    {:user_ip => ip,
      :comment_type => self.class.to_s.downcase,
      :comment_author => originator,
      :comment_author_email => email,
      :comment_author_url => url,
      :comment_content => body}
  end

  def spam_fields
    [:title, :body, :ip, :url]
  end

  # is_spam? checks to see if this is spam.
  #
  # options are passed on to Akismet.  Recommended options (when available) are:
  #
  #  :permalink => the article's URL
  #  :user_agent => the poster's UserAgent string
  #  :referer => the poster's Referer string
  #
  def is_spam?(options={})
    return false unless blog.sp_global

    sp = SpamProtection.new(blog)
    spam = false

    # Check fields against the blacklist.
    spam_fields.each do |field|
      spam ||= sp.is_spam? self.send(field)
    end

    # Attempt to use Akismet.  Timeout after 5 seconds if we can't contact them.
    unless blog.sp_akismet_key.blank?
      Timeout.timeout(5) do
        akismet = Akismet.new(blog.sp_akismet_key,blog.canonical_server_url)
        spam ||= akismet.commentCheck(akismet_options.merge(options))
      end
    end

    spam == true
  end

  def set_spam(is_spam, options ={})
    unless blog.sp_akismet_key.blank?
      Timeout.timeout(5) do
        akismet = Akismet.new(blog.sp_akismet_key,blog.canonical_server_url)
        if is_spam
          STDERR.puts "** submitting spam for #{id}"
          akismet.submitSpam(akismet_options.merge(options))
        else
          STDERR.puts "** submitting ham for #{id}"
          akismet.submitHam(akismet_options.merge(options))
        end
      end
    end
  end
end
