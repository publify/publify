class GroupingController < ContentController
  before_filter :auto_discovery_feed, :only => [:show, :index]

  layout :theme_layout

  cache_sweeper :blog_sweeper

  cached_pages = [:index, :show]
  
  protected
  
  def render_articles(articles)
    respond_to do |format|
      format.html do
        return error("Can't find any articles for '#{params[:id]}'") if articles.empty?

        @pages = Paginator.new self, articles.size, this_blog.limit_article_display, params[:page]
        @articles = articles.slice(@pages.current.offset, this_blog.limit_article_display)

        render :template => 'articles/index' unless template_exists?
      end

      format.atom { render_feed 'atom_feed',  articles }
      format.rss  { render_feed 'rss20_feed', articles }
    end
  end

  def render_feed(template, collection)
    if collection.respond_to?(:find)
      articles = collection.find(:all, :limit => this_blog.limit_rss_display)
    else
      articles = collection[0,this_blog.limit_rss_display]
    end
    render :partial => template.sub(%r{^(?:articles/)?}, 'articles/'), :object => articles
  end
end