class TrackBack

  class << self
    
    def send(article, articleurl, url)
      require 'uri'
      require 'net/http'
      begin
        uri = URI.parse(url)
        post = "title=#{URI.escape(article.subject)}"
        post << "&excerpt=#{strip_html(article.body_html)[0..255]}"
        post << "&url=#{articleurl}"
        post << "&blog_name=#{URI.escape(CONFIG['blogname'])}"

        Net::HTTP.start(uri.host) do |http|
          http.post("#{uri.path}?#{uri.query}", post)
        end
      rescue
      end
    end
    
    private

    def strip_html(text)
      attribute_key = /[\w:_-]+/
      attribute_value = /(?:[A-Za-z0-9]+|(?:'[^']*?'|"[^"]*?"))/
      attribute = /(?:#{attribute_key}(?:\s*=\s*#{attribute_value})?)/
      attributes = /(?:#{attribute}(?:\s+#{attribute})*)/
      tag_key = attribute_key
      tag = %r{<[!/?\[]?(?:#{tag_key}|--)(?:\s+#{attributes})?\s*(?:[!/?\]]+|--)?>}
      text.gsub(tag, '').gsub(/\s+/, ' ').strip
      CGI::escape(text)
    end

  end
end