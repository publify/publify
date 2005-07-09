require_dependency 'transforms'

class Comment < ActiveRecord::Base
  belongs_to :article

  validates_presence_of :author, :body
  validates_against_spamdb :body, :url, :ip
  validates_age_of :article_id
 
  protected
  
  before_save :correct_url, :make_nofollow, :transform_body, :make_nofollow

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
    # Escape HTML in comments
    self.body_html = HtmlEngine.transform(body, config["comment_text_filter"], [:filter_html]) 
  end

end
