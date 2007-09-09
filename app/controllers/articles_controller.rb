class ArticlesController < ContentController
  before_filter :verify_config
  before_filter :auto_discovery_feed, :only => [:show, :index, :author, :category, :tag]

  layout :theme_layout, :except => [:comment_preview, :trackback]

  cache_sweeper :blog_sweeper

  cached_pages = [:index, :read, :show, :category, :archives, :view_page, :tag, :author]
  caches_action_with_params *cached_pages

  session :only => %w(nuke_comment nuke_trackback nuke_feedback)
  verify(:only => [:nuke_comment, :nuke_trackback, :nuke_feedback],
         :session => :user, :method => :delete,
         :render => { :text => 'Forbidden', :status => 403 })

  def index
    @articles = this_blog.requested_articles(params)
    respond_to do |format|
      format.html { render_paginated_index }
      format.atom do
        render :partial => 'atom_feed', :object => @articles[0,this_blog.limit_rss_display]
      end
      format.rss do
        render :partial => 'rss20_feed', :object => @articles[0,this_blog.limit_rss_display]
      end
    end
  end

  def archives
    @articles = this_blog.published_articles
  end

  def show
    @article      = this_blog.requested_article(params)
    @comment      = Comment.new
    @page_title   = @article.title
    auto_discovery_feed
    respond_to do |format|
      format.html { render :action => 'read' }
      format.atom { render :partial => 'atom_feed', :object => @article.published_feedback }
      format.rss  { render :partial => 'rss20_feed', :object => @article.published_feedback }
      format.xml  { redirect_to :format => 'atom' }
    end
    rescue ActiveRecord::RecordNotFound
      error("Post not found...")
  end

  def search
    @articles = this_blog.articles_matching(params[:q])
    render_paginated_index("No articles found...")
  end

  def comment_preview
    if (params[:comment][:body].blank? rescue true)
      render :nothing => true
      return
    end

    set_headers
    @comment = this_blog.comments.build(params[:comment])
    @controller = self
  end

  def author
    render_grouping(User)
  end

  def category
    response.headers['Status'] = "301 Moved Permanently"
    redirect_to categories_path
  end

  def tag
    render_grouping(Tag)
  end

  def nuke_comment
    @comment = Comment.find(params[:id]).destroy
    render :nothing => true
  end

  def nuke_trackback
    Trackback.find(params[:id]).destroy
    render :nothing => true
  end

  def nuke_feedback
    fb = Feedback.find(params[:feedback_id]).destroy
    render :update do |page|
      page.visual_effect(:puff, "#{fb.class.to_s.underscore}-#{fb.id}")
    end
  end

  def view_page
    if(@page = Page.find_by_name(params[:name].to_a.join('/')))
      @page_title = @page.title
    else
      render :nothing => true, :status => 404
    end
  end

  def markup_help
    render :text => TextFilter.find(params[:id]).commenthelp
  end

  private

  def verify_config
    if User.count == 0
      redirect_to :controller => "accounts", :action => "signup"
    elsif ! this_blog.configured?
      redirect_to :controller => "admin/general", :action => "redirect"
    else
      return true
    end
  end

  def display_article(article = nil)
    begin
    end
  end

  alias_method :rescue_action_in_public, :error

  def render_error(object = '', status = 500)
    render(:text => (object.errors.full_messages.join(", ") rescue object.to_s), :status => status)
  end

  def set_headers
    headers["Content-Type"] = "text/html; charset=utf-8"
  end

  def list_groupings(klass)
    @grouping_class = klass
    @groupings = klass.find_all_with_article_counters(1000)
    respond_to do |format|
      format.html { render :action => 'groupings' }
    end
  end

  def render_grouping(klass)
    return list_groupings(klass) unless params[:id]

    @page_title = "#{klass.to_s.underscore} #{params[:id]}"
    @articles = klass.find_by_permalink(params[:id]).articles.find_already_published

    respond_to do |format|
      format.html do
        auto_discovery_feed
        render_paginated_index("Can't find posts with #{klass.to_prefix} '#{h(params[:id])}'")
      end
      items = @articles[0,this_blog.limit_rss_display]
      format.atom { render :partial => 'atom_feed', :object => items }
      format.rss { render :partial => 'rss20_feed', :object => items }
    end
  rescue ActiveRecord::RecordNotFound
    error "Can't find posts with #{klass.to_prefix} '#{h(params[:id])}'"
  end

  def render_paginated_index(on_empty = "No posts found...")
    return error(on_empty, :status => 200) if @articles.empty?

    @pages = Paginator.new self, @articles.size, this_blog.limit_article_display, params[:page]
    start = @pages.current.offset
    stop  = (@pages.current.next.offset - 1) rescue @articles.size
    # Why won't this work? @articles.slice!(start..stop)
    @articles = @articles.slice(start..stop)
    render :action => 'index'
  end
end
