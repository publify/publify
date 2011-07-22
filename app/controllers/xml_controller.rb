class XmlController < ApplicationController
  caches_page :feed, :if => Proc.new {|c|
    c.request.query_string == ''
  }

  NORMALIZED_FORMAT_FOR = {'atom' => 'atom', 'rss' => 'rss',
    'atom10' => 'atom', 'atom03' => 'atom', 'rss20' => 'rss',
    'googlesitemap' => 'googlesitemap', 'rsd' => 'rsd' }

  CONTENT_TYPE_FOR = { 'rss' => 'application/xml',
    'atom' => 'application/atom+xml',
    'googlesitemap' => 'application/xml' }

  def feed
    adjust_format
    @format = params[:format]

    unless @format
      return render(:text => 'Unsupported format', :status => 404)
    end

    # TODO: Move redirects into config/routes.rb, if possible
    case params[:type]
    when 'feed'
      redirect_to :controller => 'articles', :action => 'index', :format => @format, :status => :moved_permanently
    when 'comments'
      redirect_to admin_comments_url(:format => @format), :status => :moved_permanently
    when 'article'
      redirect_to Article.find(params[:id]).permalink_by_format(@format), :status => :moved_permanently
    when 'category', 'tag', 'author'
      redirect_to self.send("#{params[:type]}_url", params[:id], :format => @format), :status => :moved_permanently
    when 'trackbacks'
      redirect_to trackbacks_url(:format => @format), :status => :moved_permanently
    when 'sitemap'
      prep_sitemap

      respond_to do |format|
        format.googlesitemap
      end
    else
      return render(:text => 'Unsupported feed type', :status => 404)
    end
  end

  # TODO: Move redirects into config/routes.rb, if possible
  def articlerss
    redirect_to Article.find(params[:id]).permalink_by_format('rss'), :status => :moved_permanently
  end

  def commentrss
    redirect_to admin_comments_url(:format => 'rss'), :status => :moved_permanently
  end

  def trackbackrss
    redirect_to trackbacks_url(:format => 'rss'), :status => :moved_permanently
  end

  def rsd
    render "rsd.rsd.builder"
  end

  protected

  def adjust_format
    if params[:format]
      params[:format] = NORMALIZED_FORMAT_FOR[params[:format]]
    else
      params[:format] = 'rss'
    end
    request.format = params[:format] if params[:format]
    return true
  end

  def fetch_items(association, order='published_at DESC', limit=nil)
    if association.instance_of?(Symbol)
      association = association.to_s.singularize.classify.constantize
    end
    limit ||= this_blog.limit_rss_display
    @items += association.find_already_published(:all, :limit => limit, :order => order)
  end

  def prep_sitemap
    @items = Array.new
    @blog = this_blog

    @feed_title = this_blog.blog_name
    @link = this_blog.base_url
    @self_url = url_for(params)

    fetch_items(:articles, 'created_at DESC', 1000)
    fetch_items(:pages, 'created_at DESC', 1000)

    @items += Category.find_all_with_article_counters(1000) unless this_blog.unindex_categories
    @items += Tag.find_all_with_article_counters(1000) unless this_blog.unindex_tags
  end
end
