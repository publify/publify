class ArticlesController < ContentController
  before_filter :verify_config
  before_filter :auto_discovery_feed, :only => [:show, :index]

  layout :theme_layout, :except => [:comment_preview, :trackback]

  cache_sweeper :blog_sweeper
  caches_page :index, :read, :archives, :view_page

  helper :'admin/base'

  def index
    respond_to do |format|
      format.html { @limit = this_blog.limit_article_display }
      format.rss { @limit = this_blog.limit_rss_display }
      format.atom { @limit = this_blog.limit_rss_display }
    end
    
    unless params[:year].blank?
      @noindex = 1
      @articles = Article.paginate :page => params[:page], :conditions => { :published_at => time_delta(*params.values_at(:year, :month, :day)), :published => true }, :order => 'published_at DESC', :per_page => @limit
    else
      @noindex = 1 unless params[:page].blank?
      @articles = Article.paginate :page => params[:page], :conditions => { :published => true }, :order => 'published_at DESC', :per_page => @limit
    end
    
    @page_title = index_title
    @description = index_description
    @keywords = (this_blog.meta_keywords.empty?) ? "" : this_blog.meta_keywords
    
    respond_to do |format|
      format.html { render_paginated_index }
      format.atom do
        send_feed('atom')
      end
      format.rss do
        auto_discovery_feed(:only_path => false)
        send_feed('rss20')
      end
    end
  end

  def search
    @articles = this_blog.articles_matching(params[:q], :page => params[:page], :per_page => @limit)
    return error(_("No posts found..."), :status => 200) if @articles.empty?
    respond_to do |format|
      format.html { render :action => 'search' }
      format.rss { render :partial => "articles/rss20_feed", :object => @articles }
      format.atom { render :partial => "articles/atom_feed", :object => @articles }
    end
  end

  def live_search
    @search = params[:q]
    @articles = Article.search(@search)
    render :layout => false, :action => :live_search
  end

  ### Deprecated Actions ###

  def archives
    @articles = Article.find_published
    @page_title = "#{_('Archives for')} #{this_blog.blog_name}"
    @keywords = (this_blog.meta_keywords.empty?) ? "" : this_blog.meta_keywords
    @description = "#{_('Archives for')} #{this_blog.blog_name} - #{this_blog.blog_subtitle}"
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
    if(@page = Page.find_by_name(params[:name].map { |c| c }.join("/"))) && @page.published?
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
      redirect_to :controller => "admin/settings", :action => "redirect"
    else
      return true
    end
  end
  
  def send_feed(format)
    if this_blog.feedburner_url.empty? or request.env["HTTP_USER_AGENT"][/Feedburner/] 
      render :partial => "articles/#{format}_feed", :object => @articles
    else
      redirect_to "http://feeds2.feedburner.com/#{this_blog.feedburner_url}"
    end
  end
  
  alias_method :rescue_action_in_public, :error

  def render_error(object = '', status = 500)
    render(:text => (object.errors.full_messages.join(", ") rescue object.to_s), :status => status)
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
    render :action => 'index'
  end

  def index_title
    returning('') do |page_title|
      page_title << formatted_date_selector(_('Archives for '))

      if params[:page]
        page_title << 'Older posts' if page_title.blank?
        page_title << ", page " << params[:page]
      end
    end
  end
  
  def index_description
    returning('') do |page_description|
      if this_blog.meta_description.empty?
      page_description << "#{this_blog.blog_name} #{this_blog.blog_subtitle}" 
      else
        page_description << this_blog.meta_description
      end
      
      page_description << formatted_date_selector(_(', Articles for '))
      
      if params[:page]
        page_description << ", page " << params[:page]
      end
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
    
  def formatted_date_selector(prefix = '')
    return '' unless params[:year]
    format = prefix
    format << '%A %d ' if params[:day]
    format << '%B ' if params[:month]
    format << '%Y' if params[:year]

    return(Time.mktime(*params.values_at(:year, :month, :day)).strftime(format))
  end
end
