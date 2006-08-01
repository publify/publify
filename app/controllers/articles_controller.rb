class ArticlesController < ContentController
  before_filter :verify_config

  layout :theme_layout, :except => [:comment_preview, :trackback]

  cache_sweeper :blog_sweeper

  cached_pages = [:index, :read, :permalink, :category, :find_by_date, :archives, :view_page, :tag, :author]
  # If you're really memory-constrained, then consider replacing
  # caches_action_with_params with caches_page
  caches_action_with_params *cached_pages
  session :off, :only => cached_pages

  verify(:only => [:nuke_comment, :nuke_trackback],
         :session => :user, :method => :post,
         :render => { :text => 'Forbidden', :status => 403 })

  def index
    # On Postgresql, paginate's default count is *SLOW*, because it does a join against
    # all of the eager-loaded tables.  I've seen it take up to 7 seconds on my test box.
    #
    # So, we're going to use the older Paginator class and manually provide a count.
    # This is a 100x speedup on my box.
    count = Article.count(:conditions => ['published = ? AND contents.published_at < ? AND blog_id = ?',
      true, Time.now, this_blog.id])
    @pages = Paginator.new self, count, this_blog.limit_article_display, @params[:page]
    @articles = Article.find( :all,
      :offset => @pages.current.offset,
      :limit => @pages.items_per_page,
      :order => "contents.published_at DESC",
      :include => [:categories, :tags, :user, :blog],
      :conditions =>
         ['published = ? AND contents.published_at < ? AND blog_id = ?',
          true, Time.now, this_blog.id]
    )
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

  def archives
    @articles = this_blog.published_articles
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
    render :action => 'error'
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
    unless @request.xhr? || this_blog.sp_allow_non_ajax_comments
      render_error("non-ajax commenting is disabled")
      return
    end

    if request.post?
      begin
        @article = this_blog.published_articles.find(params[:id])
        params[:comment].merge!({:ip => request.remote_ip,
                                :published => true,
                                :user => session[:user],
                                :user_agent => request.env['HTTP_USER_AGENT'],
                                :referrer => request.env['HTTP_REFERER'],
                                :permalink => this_blog.article_url(@article, false)})
        @comment = @article.comments.create!(params[:comment])
        add_to_cookies(:author, @comment.author)
        add_to_cookies(:url, @comment.url)

        set_headers
        render :partial => "comment", :object => @comment
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
      elsif !(params.has_key?(:url) && params.has_key?(:id))
        throw :error, "A URL is required"
      else
        begin
          settings = { :id => params[:id],
                       :url => params[:url],      :blog_name => params[:blog_name],
                       :title => params[:title],  :excerpt => params[:excerpt],
                       :ip  => request.remote_ip, :published => true }
          this_blog.ping_article!(settings)
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

  def add_to_cookies(name, value, path=nil, expires=nil)
    cookies[name] = { :value => value, :path => path || "/#{controller_name}",
                       :expires => 6.weeks.from_now }
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
      @article      = block_given? ? yield : article
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

    @page_title = "#{this_blog.blog_name} - #{klass.to_s.underscore} #{params[:id]}"
    @articles = klass.find_by_permalink(params[:id]).articles.find_already_published rescue []
    auto_discovery_feed :type => klass.to_s.underscore, :id => params[:id]
    render_paginated_index("Can't find posts with #{klass.to_prefix} '#{h(params[:id])}'")
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
