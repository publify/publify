require_dependency 'transforms'

class Comment < ActiveRecord::Base
  belongs_to :article

  protected
  
    validates_presence_of :author, :email, :body
    validates_format_of :email, :with => Format::EMAIL  
    before_save :make_nofollow, :correct_url, :transform_body

    def correct_url
      unless url.to_s.empty?
        unless url =~ /^http\:\/\//
          self.url = "http://#{url}"
        end
      end
    end

    def make_nofollow
      self.body = nofollowify(body) 
      self.author = nofollowify(author) 
    end

    def transform_body
      self.body_html = HtmlEngine.transform(body)
    end

end
