require_dependency 'transforms'

class Comment < Content
  include TypoGuid

  content_fields :body
  
  belongs_to :article
  belongs_to :user

  validates_presence_of :author, :body
  validates_against_spamdb :body, :url, :ip
  validates_age_of :article_id
 
  protected
  
  def default_text_filter_config_key
    'comment_text_filter'
  end
  
  before_save :correct_url, :make_nofollow, :create_guid
    
  def correct_url
    unless url.to_s.empty?
      unless url =~ /^http\:\/\//
        self.url = "http://#{url}"
      end
    end
  end

  def make_nofollow
    self.author = nofollowify(author)
    self.body_html = nofollowify(body_html.to_s)
  end
end
