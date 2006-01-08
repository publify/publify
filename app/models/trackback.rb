class Trackback < Content
  include TypoGuid
  belongs_to :article, :counter_cache => true

  content_fields :excerpt

  validates_age_of :article_id
  validates_against_spamdb :title, :excerpt, :ip, :url
  validates_presence_of :title, :excerpt, :blog_name, :url

  protected
    before_create :make_nofollow, :process_trackback, :create_guid

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
end

