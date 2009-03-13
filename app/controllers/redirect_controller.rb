class RedirectController < ContentController
  before_filter :verify_config

  layout :theme_layout

  cache_sweeper :blog_sweeper

  caches_page :redirect

  helper :'admin/base'

  def self.controller_path
    'articles'
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


  private

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

  def render_feed(type)
    render :partial => "/articles/#{type}_feed", :object => @article.published_feedback 
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

  # Test in fist time if we need create some data
  # Use only in bootstraping
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
