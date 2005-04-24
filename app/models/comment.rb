require_dependency 'transforms'

class Comment < ActiveRecord::Base
  belongs_to :article

  validates_presence_of :author, :body
  validates_against_spamdb :body, :url, :ip
  validates_age_of :article_id
 
  protected
  
    before_save :make_nofollow, :correct_url, :transform_body

    def correct_url
      unless url.to_s.empty?
        unless url =~ /^http\:\/\//
          self.url = "http://#{url}"
        end
      end
    end

    def make_nofollow
      self.author = nofollowify(author)
      self.body = nofollowify(body)
    end

    def transform_body
      self.body_html = HtmlEngine.transform(body, config["text_filter"], [:filter_html]) # Escape HTML in comments
    end

end
