class Comment < ActiveRecord::Base
  belongs_to :article

  protected
  
    validates_presence_of :author, :email, :body
    validates_format_of :email, :with => Format::EMAIL  

    before_save :correct_url
    def correct_url
      unless url.to_s.empty?
        unless url =~ /^http\:\/\//
          self.url = "http://#{url}"
        end
      end
    end

  
    before_save :transform_body
    def transform_body
      self.body_html = HtmlEngine.transform(body)
    end
end
