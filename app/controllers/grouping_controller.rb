class GroupingController < ContentController
  before_filter :auto_discovery_feed, :only => [:show, :index]
  layout :theme_layout
  cache_sweeper :blog_sweeper
  cached_pages = [:index, :show]

  class << self
    def grouping_class(klass = nil)
      if klass
        @grouping_class = klass
      end
      @grouping_class ||= \
        self.to_s \
        .sub(/Controller$/,'') \
        .singularize.constantize
    end

    def ivar_name
      @ivar_name ||= "@#{to_s.sub(/Controller$/, '').underscore}"
    end
  end

  def index
    groupings = instance_variable_set(ivar_name, grouping_class.find_all_with_article_counters(1000))
    render_index(groupings)
  end

  def show
    grouping = grouping_class.find_by_permalink(params[:id])
    @page_title = "#{self.class.to_s.sub(/Controller$/,'').singularize} #{params[:id]}"
    render_articles(grouping.published_articles)
  end

  protected

  def grouping_class
    self.class.grouping_class
  end

  def ivar_name
    self.class.ivar_name
  end

  def render_index(groupings)
    respond_to do |format|
      format.html do
        unless template_exists?
          @grouping_class = self.class.grouping_class
          @groupings = groupings
          render :template => 'articles/groupings'
        end
      end
    end
  end

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
