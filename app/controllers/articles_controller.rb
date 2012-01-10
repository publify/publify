class ArticlesController < ContentController
  before_filter :login_required, :only => [:preview]
  before_filter :auto_discovery_feed, :only => [:show, :index]
  before_filter :verify_config

  layout :theme_layout, :except => [:comment_preview, :trackback]

  cache_sweeper :blog_sweeper
  caches_page :index, :read, :archives, :view_page, :redirect, :if => Proc.new {|c|
    c.request.query_string == ''
  }

  helper :'admin/base'

  def index
    respond_to do |format|
      format.html { @limit = this_blog.limit_article_display }
      format.rss { @limit = this_blog.limit_rss_display }
      format.atom { @limit = this_blog.limit_rss_display }
    end

    unless params[:year].blank?
      @noindex = 1
      @articles = Article.published_at(params.values_at(:year, :month, :day)).page(params[:page]).per(@limit)
    else
      @noindex = 1 unless params[:page].blank?
      @articles = Article.published.page(params[:page]).per(@limit)
    end

    @page_title = index_title
    @description = index_description
    @keywords = (this_blog.meta_keywords.empty?) ? "" : this_blog.meta_keywords

    suffix = (params[:page].nil? and params[:year].nil?) ? "" : "/"

    @canonical_url = url_for(:only_path => false, :controller => 'articles', :action => 'index', :page => params[:page], :year => params[:year], :month => params[:month], :day => params[:day]) + suffix
    respond_to do |format|
      format.html { render_paginated_index }
      format.atom do
        render_articles_feed('atom')
      end
      format.rss do
        auto_discovery_feed(:only_path => false)
        render_articles_feed('rss')
      end
    end
  end

  def search
    @canonical_url = url_for(:only_path => false, :controller => 'articles', :action => 'search', :page => params[:page], :q => params[:q])
    @articles = this_blog.articles_matching(params[:q], :page => params[:page], :per_page => @limit)
    return error(_("No posts found..."), :status => 200) if @articles.empty?
    @page_title = this_blog.search_title_template.to_title(@articles, this_blog, params)
    @description = this_blog.search_desc_template.to_title(@articles, this_blog, params)
    respond_to do |format|
      format.html { render 'search' }
      format.rss { render "index_rss_feed", :layout => false }
      format.atom { render "index_atom_feed", :layout => false }
    end
  end

  def live_search
    @search = params[:q]
    @articles = Article.search(@search)
    render :live_search, :layout => false
  end

  def preview
    @article = Article.last_draft(params[:id])
    @canonical_url = ""
    render 'read'
  end

  def check_password
    return unless request.xhr?
    @article = Article.find(params[:article][:id])
    if @article.password == params[:article][:password]
      render :partial => 'articles/full_article_content', :locals => { :article => @article }
    else
      render :partial => 'articles/password_form', :locals => { :article => @article }
    end
  end

  def redirect
    from = split_from_path params[:from]

    match_permalink_format from, this_blog.permalink_format
    return show_article if @article

    # Redirect old version with /:year/:month/:day/:title to new format,
    # because it's changed
    ["%year%/%month%/%day%/%title%", "articles/%year%/%month%/%day%/%title%"].each do |part|
      match_permalink_format from, part
      return redirect_to @article.permalink_url, :status => 301 if @article
    end

    r = Redirect.find_by_from_path(from.join("/"))
    return redirect_to r.full_to_path, :status => 301 if r

    render "errors/404", :status => 404
  end


  ### Deprecated Actions ###

  def archives
    @articles = Article.find_published
    @page_title = this_blog.archives_title_template.to_title(@articles, this_blog, params)
    @keywords = (this_blog.meta_keywords.empty?) ? "" : this_blog.meta_keywords
    @description = this_blog.archives_desc_template.to_title(@articles, this_blog, params)
    @canonical_url = url_for(:only_path => false, :controller => 'articles', :action => 'archives')
  end

  def comment_preview
    if (params[:comment][:body].blank? rescue true)
      render :nothing => true
      return
    end

    set_headers
    @comment = Comment.new(params[:comment])
    @controller = self
  end

  def category
    redirect_to categories_path, :status => 301
  end

  def tag
    redirect_to tags_path, :status => 301
  end

  def view_page
    if(@page = Page.find_by_name(Array(params[:name]).map { |c| c }.join("/"))) && @page.published?
      @page_title = @page.title
      @description = (this_blog.meta_description.empty?) ? "" : this_blog.meta_description
      @keywords = (this_blog.meta_keywords.empty?) ? "" : this_blog.meta_keywords
      @canonical_url = @page.permalink_url
    else
      render "errors/404", :status => 404
    end
  end

  # TODO: Move to TextfilterController?
  def markup_help
    render :text => TextFilter.find(params[:id]).commenthelp
  end

  private

  def verify_config
    if  ! this_blog.configured?
      redirect_to :controller => "setup", :action => "index"
    elsif User.count == 0
      redirect_to :controller => "accounts", :action => "signup"
    else
      return true
    end
  end

  # See an article We need define @article before
  def show_article
    @comment      = Comment.new
    @page_title   = this_blog.article_title_template.to_title(@article, this_blog, params)
    @description = this_blog.article_desc_template.to_title(@article, this_blog, params)
    article_meta

    auto_discovery_feed
    respond_to do |format|
      format.html { render "articles/#{@article.post_type}" }
      format.atom { render_feedback_feed('atom') }
      format.rss  { render_feedback_feed('rss') }
      format.xml  { render_feedback_feed('atom') }
    end
  rescue ActiveRecord::RecordNotFound
    error("Post not found...")
  end


  def article_meta
    groupings = @article.categories + @article.tags
    @keywords = groupings.map { |g| g.name }.join(", ")
    @canonical_url = @article.permalink_url
  end

  def render_articles_feed format
    if this_blog.feedburner_url.empty? or request.env["HTTP_USER_AGENT"] =~ /FeedBurner/i
      render "index_#{format}_feed", :layout => false
    else
      redirect_to "http://feeds2.feedburner.com/#{this_blog.feedburner_url}"
    end
  end

  def render_feedback_feed format
    @feedback = @article.published_feedback
    render "feedback_#{format}_feed", :layout => false
  end

  def set_headers
    headers["Content-Type"] = "text/html; charset=utf-8"
  end

  def render_paginated_index(on_empty = _("No posts found..."))
    return error(on_empty, :status => 200) if @articles.empty?
    if this_blog.feedburner_url.empty?
      auto_discovery_feed(:only_path => false)
    else
      @auto_discovery_url_rss = "http://feeds2.feedburner.com/#{this_blog.feedburner_url}"
      @auto_discovery_url_atom = "http://feeds2.feedburner.com/#{this_blog.feedburner_url}"
    end
    render 'index'
  end

  def index_title
    if params[:year]
      return this_blog.archives_title_template.to_title(@articles, this_blog, params)
    elsif params[:page]
      return this_blog.paginated_title_template.to_title(@articles, this_blog, params)
    else
      this_blog.home_title_template.to_title(@articles, this_blog, params)
    end
  end

  def index_description
    if params[:year]
      return this_blog.archives_desc_template.to_title(@articles, this_blog, params)
    elsif params[:page]
      return this_blog.paginated_desc_template.to_title(@articles, this_blog, params)
    else
      this_blog.home_desc_template.to_title(@articles, this_blog, params)
    end
  end

  def time_delta(year, month = nil, day = nil)
    from = Time.mktime(year, month || 1, day || 1)

    to = from.next_year
    to = from.next_month unless month.blank?
    to = from + 1.day unless day.blank?
    to = to - 1 # pull off 1 second so we don't overlap onto the next day
    return from..to
  end

  def split_from_path path
    parts = path.split '/'
    parts.delete('')
    if parts.last =~ /\.atom$/
      request.format = 'atom'
      parts.last.gsub!(/\.atom$/, '')
    elsif parts.last =~ /\.rss$/
      request.format = 'rss'
      parts.last.gsub!(/\.rss$/, '')
    end
    parts
  end

  def match_permalink_format parts, format
    specs = format.split('/')
    specs.delete('')

    return if parts.length != specs.length

    article_params = {}

    specs.zip(parts).each do |spec, item|
      if spec =~ /(.*)%(.*)%(.*)/
        before_format = $1
        format_string = $2
        after_format = $3
        result = item.gsub(/^#{before_format}(.*)#{after_format}$/, '\1')
        article_params[format_string.to_sym] = result
      else
        return unless spec == item
      end
    end
    begin
      @article = this_blog.requested_article(article_params)
    rescue
      #Not really good.
      # TODO :Check in request_article type of DATA made in next step
    end
  end
end
