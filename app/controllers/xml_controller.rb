class XmlController < ApplicationController
  caches_page :feed, if: proc {|c|
    c.request.query_string == ''
  }

  NORMALIZED_FORMAT_FOR = { 'atom' => 'atom', 'rss' => 'rss',
                            'atom10' => 'atom', 'atom03' => 'atom', 'rss20' => 'rss',
                            'googlesitemap' => 'googlesitemap', 'rsd' => 'rsd' }

  ACCEPTED_TYPE =  %w(feed comments article tag author trackbacks sitemap)

  def feed
    @format = 'rss'
    if params[:format]
      @format = NORMALIZED_FORMAT_FOR[params[:format]]
      return render(text: 'Unsupported format', status: 404) unless @format
    end

    # TODO: Move redirects into config/routes.rb, if possible
    param_type = ACCEPTED_TYPE.dup.delete(params[:type])
    param_id = params[:id] # .present? && params[:id].to_i # Think about a way to secure that to a valid tag/author for int value ...

    case param_type
    when 'feed'
      redirect_to controller: 'articles', action: 'index', format: @format, status: :moved_permanently
    when 'comments'
      redirect_to admin_comments_url(format: @format), status: :moved_permanently
    when 'article'
      redirect_to Article.find(param_id).feed_url(@format), status: :moved_permanently
    when 'tag', 'author'
      redirect_to send("#{param_type}_url", param_id, format: @format), status: :moved_permanently
    when 'trackbacks'
      redirect_to trackbacks_url(format: @format), status: :moved_permanently
    when 'sitemap'
      @items = []
      @blog = this_blog

      @feed_title = this_blog.blog_name
      @link = this_blog.base_url
      @self_url = url_for(params)

      @items += Article.find_already_published(1000)
      @items += Page.find_already_published(1000)
      @items += Tag.find_all_with_article_counters unless this_blog.unindex_tags

      respond_to do |format|
        format.googlesitemap
      end
    else
      return render(text: 'Unsupported feed type', status: 404)
    end
  end

  # TODO: Move redirects into config/routes.rb, if possible
  def articlerss
    redirect_to(URI.parse(Article.find(params[:id]).feed_url('rss')).path, status: :moved_permanently)
  end

  def commentrss
    redirect_to admin_comments_url(format: 'rss'), status: :moved_permanently
  end

  def trackbackrss
    redirect_to trackbacks_url(format: 'rss'), status: :moved_permanently
  end

  def rsd
    render 'rsd', formats: [:rsd], handlers: [:builder]
  end
end
