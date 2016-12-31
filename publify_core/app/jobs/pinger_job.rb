class PingerJob < ApplicationJob
  queue_as :default

  def perform(article)
    blog = article.blog
    return unless blog.send_outbound_pings?

    blog.urls_to_ping_for(article).each do |url_to_ping|
      url_to_ping.send_weblogupdatesping(blog.base_url, article.permalink_url)
    end

    article.html_urls_to_ping.each do |url_to_ping|
      url_to_ping.send_pingback_or_trackback(article.permalink_url)
    end
  end
end
