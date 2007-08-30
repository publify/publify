class CategoriesController < ContentController
  before_filter :auto_discovery_feed, :only => [:show, :index]

  layout :theme_layout

  cache_sweeper :blog_sweeper

  cached_pages = [:index, :show]

  def index
    @categories = Category.find_all_with_article_counters(1000)
    respond_to do |format|
      format.html do
        unless template_exists?
          @grouping_class = Category
          @groupings = @categories
          render :template => 'articles/groupings'
        end
      end
    end
  end

  def show
    @page_title = "category #{params[:id]}"
    @category = Category.find_by_permalink(params[:id])

    respond_to do |format|
      format.html do
        @articles = @category.published_articles
        return error("Can't find posts with category '#{params[:id]}'") if @articles.empty?

        @pages = Paginator.new self, @articles.size, this_blog.limit_article_display, params[:page]
        @articles = @articles.slice(@pages.current.offset, this_blog.limit_article_display)

        render :template => 'articles/index' unless template_exists?
      end

      format.atom { render_feed 'atom_feed', @category.published_articles }
      format.rss  { render_feed 'rss20_feed',  @category.published_articles }
    end
  end

  protected

  def render_feed(template, collection)
    if collection.respond_to?(:find)
      articles = collection.find(:all, :limit => this_blog.limit_rss_display)
    else
      articles = collection[0,this_blog.limit_rss_display]
    end
    render :partial => template.sub(%r{^(?:articles/)?}, 'articles/'), :object => articles
  end
end
