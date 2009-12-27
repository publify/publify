class ArticlesController < ContentController
  before_filter :verify_config
  before_filter :login_required, :only => [:preview]
  before_filter :auto_discovery_feed, :only => [:show, :index]

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

  def preview
    @article = Article.last_draft(params[:id])
    render :action => 'read'
  end

  def redirect
    part = this_blog.permalink_format.split('/')
    part.delete('') # delete all par of / where no data. Avoid all // or / started
    params[:from].delete('')
    if params[:from].last =~ /\.atom$/
      params[:format] = 'atom'
      params[:from].last.gsub!(/\.atom$/, '')
    elsif params[:from].last =~ /\.rss$/
      params[:format] = 'rss'
      params[:from].last.gsub!(/\.rss$/, '')
    end
    zip_part = part.zip(params[:from])
    article_params = {}
    zip_part.each do |asso|
      ['%year%', '%month%', '%day%', '%title%'].each do |format_string|
        if asso[0] =~ /(.*)#{format_string}(.*)/
          before_format = $1
          after_format = $2
          next if asso[1].nil?
          result =  asso[1].gsub(before_format, '')
          result.gsub!(after_format, '')
          article_params[format_string.gsub('%', '').to_sym] = result
        end
      end
    end
    begin
      @article = this_blog.requested_article(article_params)
    rescue
      #Not really good. 
      # TODO :Check in request_article type of DATA made in next step
    end
    return show_article if @article

    # Redirect old version with /:year/:month/:day/:title to new format.
    # because it's change
    ["%year%/%month%/%day%/%title%".split('/'), "articles/%year%/%month%/%day%/%title%".split('/')].each do |part|
      part.delete('') # delete all par of / where no data. Avoid all // or / started
      params[:from].delete('')
      zip_part = part.zip(params[:from])
      article_params = {}
      zip_part.each do |asso|
        ['%year%', '%month%', '%day%', '%title%'].each do |format_string|
          if asso[0] =~ /(.*)#{format_string}(.*)/
            before_format = $1
            after_format = $2
            next if asso[1].nil?
            result =  asso[1].gsub(before_format, '')
            result.gsub!(after_format, '')
            article_params[format_string.gsub('%', '').to_sym] = result
          end
        end
      end
      begin
        @article = this_blog.requested_article(article_params)
      rescue
        #Not really good. 
        # TODO :Check in request_article type of DATA made in next step
      end
      if @article
        redirect_to @article.permalink_url, :status => 301
        return
      end
    end


    # see how manage all by this redirect to redirect in different possible
    # way maybe define in a controller in admin part in insert in this table
    r = Redirect.find_by_from_path(params[:from].join("/"))

    if(r)
      path = r.to_path
      url_root = self.class.relative_url_root
      path = url_root + path unless url_root.nil? or path[0,url_root.length] == url_root
      redirect_to path, :status => 301
    else
      render :text => "Page not found", :status => 404
    end
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
  
  # See an article We need define @article before
  def show_article
    @comment      = Comment.new
    @page_title   = @article.title
    article_meta
    
    auto_discovery_feed
    respond_to do |format|
      format.html { render :template => '/articles/read' }
      format.atom { render_feed('atom') }
      format.rss  { render_feed('rss20') }
      format.xml  { render_feed('atom') }
    end
  rescue ActiveRecord::RecordNotFound
    error("Post not found...")
  end

  def article_meta
    @keywords = ""
    @keywords << @article.categories.map { |c| c.name }.join(", ") << ", " unless @article.categories.empty?
    @keywords << @article.tags.map { |t| t.name }.join(", ") unless @article.tags.empty?  
    @description = "#{@article.title}, " 
    @description << @article.categories.map { |c| c.name }.join(", ") << ", " unless @article.categories.empty?
    @description << @article.tags.map { |t| t.name }.join(", ") unless @article.tags.empty?
    @description << " #{this_blog.blog_name}"
  end

  def send_feed(format)
    if this_blog.feedburner_url.empty? or request.env["HTTP_USER_AGENT"] =~ /FeedBurner/i
      render :partial => "articles/#{format}_feed", :object => @articles
    else
      redirect_to "http://feeds2.feedburner.com/#{this_blog.feedburner_url}"
    end
  end
  
  # TODO: Merge with send_feed?
  def render_feed(type)
    render :partial => "/articles/#{type}_feed", :object => @article.published_feedback 
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
