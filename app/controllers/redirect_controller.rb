class RedirectController < ContentController
  before_filter :verify_config
  before_filter :auto_discovery_feed, :only => [:show, :index]

  layout :theme_layout, :except => [:comment_preview, :trackback]

  cache_sweeper :blog_sweeper

  cached_pages = [:index, :read, :show, :archives, :view_page]

  caches_page *cached_pages

  helper :'admin/base'

  def self.controller_path
    'articles'
  end

  def redirect
    part = this_blog.permalink_format.split('/')
    part.delete('') # delete all par of / where no data. Avoid all // or / started
    year = params[:from][part.index('%year%')]
    month = params[:from][part.index('%month%')]
    day = params[:from][part.index('%day%')]
    title = params[:from][part.index('%title%')]
    begin
      @article = this_blog.requested_article({:year => year, :month => month, :day => day, :id => title})
    rescue
      #Not really good. 
      # TODO :Check in request_article type of DATA made in next step
    end
    return show_article if @article

    if (params[:from].first == 'articles')
      path = params[:from][1..-1].join('/') # get all params without first ('articles')
      url_root = self.class.relative_url_root
      path = url_root + '/' + path unless url_root.nil?
      redirect_to path, :status => 301
      return
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

  def show_article
    @comment      = Comment.new
    @page_title   = @article.title
    article_meta
    
    auto_discovery_feed
    respond_to do |format|
      format.html { render :template => '/articles/read' }
      format.atom { render :partial => '/articles/atom_feed', :object => @article.published_feedback }
      format.rss  { render :partial => '/articles/rss20_feed', :object => @article.published_feedback }
      format.xml  { redirect_to :format => 'atom' }
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

  def verify_config
    if User.count == 0
      redirect_to :controller => "accounts", :action => "signup"
    elsif ! this_blog.configured?
      redirect_to :controller => "admin/settings", :action => "redirect"
    else
      return true
    end
  end

end
