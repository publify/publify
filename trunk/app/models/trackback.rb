require_dependency 'transforms'

class Trackback < ActiveRecord::Base
  belongs_to :article

  protected
    before_save :make_nofollow, :process_trackback

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

