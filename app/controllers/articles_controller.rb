class ArticlesController < ContentController
  before_filter :verify_config
  before_filter :check_page_query_param_for_missing_routes

  layout :theme_layout, :except => [:comment_preview, :trackback]

  cache_sweeper :blog_sweeper

  cached_pages = [:index, :read, :permalink, :category, :find_by_date, :archives, :view_page, :tag]
  # If you're really memory-constrained, then consider replacing caches_action_with_params with caches_page
  caches_action_with_params *cached_pages
  session :off, :only => cached_pages

  verify(:only => [:nuke_comment, :nuke_trackback],
         :session => :user, :method => :post,
         :render => { :text => 'Forbidden', :status => 403 })

  def index
    @pages, @articles =
      paginate(:article, :per_page => this_blog.limit_article_display,
               :conditions =>
                 ['published = ? AND contents.created_at < ? AND blog_id = ?',
                             true,            Time.now,     this_blog.id],
               :order_by => "contents.created_at DESC",
               :include => [:categories, :tags])
  end

  def search
    @articles = this_blog.published_articles.search(params[:q])
    render_paginated_index("No articles found...")
  end

  def comment_preview
    render :nothing => true and return if params[:comment].blank? or params[:comment][:body].blank?

    set_headers
    @comment = this_blog.comments.build(params[:comment])
    @controller = self
  end

  def archives
    @articles = this_blog.published_articles.before(Time.now)
  end

  def read
    display_article { this_blog.published_articles.find(params[:id]) }
  end

  def permalink
    display_article(this_blog.published_articles.find_by_permalink(*params.values_at(:year, :month, :day, :title)))
  end

  def find_by_date
    @articles = this_blog.published_articles.find_all_by_date(params[:year], params[:month], params[:day])
    render_paginated_index
  end

  def error(message = "Record not found...")
    @message = message.to_s
    render :action => "error"
  end

  def category
    render_grouping(Category)
  end

  def tag
    render_grouping(Tag)
  end

  # Receive comments to articles
  def comment
    unless @request.xhr? || this_blog.sp_allow_non_ajax_comments
      render_error("non-ajax commenting is disabled")
      return
    end

    if request.post?
      begin
        params[:comment].merge({:ip => request.remote_ip,
                                :published => true })
        @article = this_blog.published_articles.find(params[:id])
        @comment = @article.comments.build(params[:comment])
        @comment.user = session[:user]
        @comment.save!
        add_to_cookies(:author, @comment.author)
        add_to_cookies(:url, @comment.url)

        set_headers
        render :partial => "comment", :object => @comment
        @comment.send_notifications(self)
      rescue ActiveRecord::RecordInvalid
        STDERR.puts @comment.errors.inspect
        render_error(@comment)
      end
    end
  end

  # Receive trackbacks linked to articles
  def trackback
    @error_message = catch(:error) do
      if params[:__mode] == "rss"
        # Part of the trackback spec... will implement later
        # XXX. Should this throw an error?
      elsif !(params.has_key(:url) && params.has_key?(:id))
        throw :error, "A URL is required"
      else
        begin
          params[:ip] = request.remote_ip
          params[:published] = true
          this_blog.ping_article!(params)
        rescue ActiveRecord::RecordNotFound, ActiveRecord::StatementInvalid
          throw :error, "Article id #{params[:id]} not found."
        rescue ActiveRecord::RecordInvalid
          throw :error, "Trackback not saved"
        end
      end
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

  private

  def add_to_cookies(name, value, path=nil, expires=nil)
    cookies[name] = { :value => value, :path => path || "/#{controller_name}",
                       :expires => 6.weeks.from_now }
  end

  def check_page_query_param_for_missing_routes
    unless request.path =~ /\/page\//  # check if all page routes use /page/:page
      raise "Page param problem" unless params[:page].nil?
    end
  end

  def verify_config
    if User.count == 0
      redirect_to :controller => "accounts", :action => "signup"
    elsif ! this_blog.is_ok?
      redirect_to :controller => "admin/general", :action => "redirect"
    else
      return true
    end
  end

  def display_article(article = nil)
    begin
      @article      = article || yield
      @comment      = Comment.new
      @page_title   = @article.title
      auto_discovery_feed :type => 'article', :id => @article.id
      render :action => 'read'
    rescue ActiveRecord::RecordNotFound, NoMethodError => e
      error("Post not found...")
    end
  end

  alias_method :rescue_action_in_public, :error

  def render_error(object = '', status = 500)
    render(:text => (object.errors.full_messages.join(", ") rescue object.to_s), :status => status)
  end

  def set_headers
    @headers["Content-Type"] = "text/html; charset=utf-8"
  end

  def list_groupings(klass)
    @grouping_class = klass
    @groupings = klass.find_all_with_article_counters(1000)
    render :action => 'groupings'
  end

  def render_grouping(klass)
    return list_groupings(klass) unless params[:id]

    @articles = klass.find_by_permalink(params[:id]).articles.find_already_published
    auto_discovery_feed :type => klass.to_s.underscore, :id => params[:id]
    render_paginated_index("Can't find posts with #{klass.to_s.underscore} #{params[:id]}")
  end

  def render_paginated_index(on_empty = "No posts found...")
    return error(on_empty) if @articles.empty?

    @pages = Paginator.new self, @articles.size, this_blog.limit_article_display, @params[:page]
    start = @pages.current.offset
    stop  = (@pages.current.next.offset - 1) rescue @articles.size
    # Why won't this work? @articles.slice!(start..stop)
    @articles = @articles.slice(start..stop)
    render :action => 'index'
  end
end
