class TrackbackController < ApplicationController

  # Receive trackbacks linked to articles
  def ping
    @result = true
    article = Article.find(@params['id'])
    tb = Trackback.new

    # url is required
    if ! @params.has_key?('url')
      @result = false 
      @error_message = "A url is required."
    else
      tb.url = @params['url']
      if @params.has_key?('title')
        tb.title = @params['title']
      else
        tb.title = tb.url
      end
      if @params['excerpt'].length >= 252
        tb.excerpt = @params['excerpt'][0..252] << "..."
      else
        tb.excerpt = @params['excerpt']
      end
      tb.blog_name = @params['blog_name']
      article.trackbacks << tb
      article.save
    end
  end

end

