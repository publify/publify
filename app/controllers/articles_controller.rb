class ArticlesController < ContentController
  before_filter :verify_config
  before_filter :auto_discovery_feed, :only => [:show, :index, :author, :category, :tag]

  layout :theme_layout, :except => [:comment_preview, :trackback]

  cache_sweeper :blog_sweeper

  cached_pages = [:index, :read, :show, :category, :archives, :view_page, :tag, :author]
  # If you're really memory-constrained, then consider replacing
  # caches_action_with_params with caches_page
  caches_action_with_params *cached_pages

  session :only => %w(nuke_comment nuke_trackback)
  verify(:only => [:nuke_comment, :nuke_trackback],
         :session => :user, :method => :post,
         :render => { :text => 'Forbidden', :status => 403 })

  def index
    @articles = this_blog.published_articles.find_all_by_date(*params.values_at(:year, :month, :day))
    respond_to do |format|
      format.html { render_paginated_index }
      @feed_title = this_blog.blog_name
      format.atom do
        render :partial => 'atom_feed', :object => @articles
      end
      format.rss do
        render :partial => 'rss20_feed', :object => @articles
      end
    end
  end

  def archives
    @articles = this_blog.published_articles
  end

  def show
    @article      = this_blog.published_articles.find_by_params_hash(params)
    @comment      = Comment.new
    @page_title   = @article.title
    auto_discovery_feed
    respond_to do |format|
      format.html { render :action => 'read' }
      @feed_title = "#{this_blog.blog_name} : #{@page_title}"
      feedback = @article.feedback.find_all_by_published(true)
      format.atom { render :partial => 'atom_feed', :object => feedback }
      format.rss { render :partial => 'rss20_feed', :object => feedback }
      format.xml { redirect_to :format => 'atom' }
    end
    rescue ActiveRecord::RecordNotFound
      error("Post not found...")
  end

  def search
    @articles = this_blog.published_articles.search(params[:q])
    render_paginated_index("No articles found...")
  end

  def comment_preview
    if params[:comment].blank? or params[:comment][:body].blank?
      render :nothing => true
      return
    end

    set_headers
    @comment = this_blog.comments.build(params[:comment])
    @controller = self
  end

  def error(message = "Record not found...", options = { })
    @message = message.to_s
    render :action => 'error', :status => options[:status] || 404
  end

  def author
    render_grouping(User)
  end

  def category
    render_grouping(Category)
  end

  def tag
    render_grouping(Tag)
  end

  # Receive comments to articles
  def comment
    unless request.xhr? || this_blog.sp_allow_non_ajax_comments
      render_error("non-ajax commenting is disabled")
      return
    end

    @article = this_blog.published_articles.find_by_params_hash(params)
    params[:comment].merge!({:ip => request.remote_ip,
                              :published => true,
                              :user => session[:user],
                              :user_agent => request.env['HTTP_USER_AGENT'],
                              :referrer => request.env['HTTP_REFERER'],
                              :permalink => @article.permalink_url})
    @comment = @article.comments.build(params[:comment])
    @comment.author ||= 'Anonymous'
    @comment.save
    add_to_cookies(:author, @comment.author)
    add_to_cookies(:url, @comment.url)

    set_headers
    render :partial => "comment", :object => @comment
  end

  # Receive trackbacks linked to articles
  def trackback
    @error_message = catch(:error) do
      if this_blog.global_pings_disable
        throw :error, "Trackback not saved"
      elsif params[:__mode] == "rss"
        # Part of the trackback spec... will implement later
        # XXX. Should this throw an error?
      elsif !(params.has_key?(:url) && params.has_key?(:id))
        throw :error, "A URL is required"
      else
        begin
          this_blog.ping_article!(params.merge(:ip => request.remote_ip, :published => true))
        rescue ActiveRecord::RecordNotFound, ActiveRecord::StatementInvalid
          throw :error, "Article id #{params[:id]} not found."
        rescue ActiveRecord::RecordInvalid
          throw :error, "Trackback not saved"
        end
      end
      nil
    end
  end

  def nuke_comment
    Comment.find(params[:id]).destroy
    render :nothing => true
  end

  def nuke_trackback
    Trackback.find(params[:id]).destroy
    render :nothing => true
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
      @feed_title = "#{this_blog.blog_name} : #{@page_title}"
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
