require_dependency 'transforms'

class Trackback < ActiveRecord::Base
  include TypoGuid
  belongs_to :article

  validates_age_of :article_id
  validates_against_spamdb :title, :excerpt, :ip, :url
  validates_presence_of :title, :excerpt, :blog_name, :url

  protected
    before_save :make_nofollow, :process_trackback, :create_guid

    def make_nofollow
      self.blog_name = strip_html(blog_name)
      self.title = strip_html(title)
      self.excerpt = strip_html(excerpt)
    end

    def process_trackback
      if excerpt.length >= 251
        self.excerpt = excerpt[0..251] << "..."
      end
    end
end

