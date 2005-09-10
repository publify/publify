class Ping < ActiveRecord::Base
  belongs_to :article
  
  def send_ping(origin_url)
    uri = URI.parse(self.url)
    post = "title=#{URI.escape(article.title)}"
    post << "&excerpt=#{URI.escape(strip_html(article.body_html)[0..254])}"
    post << "&url=#{origin_url}"
    post << "&blog_name=#{URI.escape(config[:blog_name])}"

    Net::HTTP.start(uri.host, uri.port) do |http|
      http.post("#{uri.path}?#{uri.query}", post)
    end
  end
end
