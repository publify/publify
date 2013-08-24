class StatusesController < ContentController
  require 'json'
  
  layout :theme_layout
  cache_sweeper :blog_sweeper
  caches_page :index, :show, :if => Proc.new {|c|
    c.request.query_string == ''
  }
  
  def index
    @statuses = Status.published.page(params[:page]).per(this_blog.limit_article_display)
    @keywords = this_blog.meta_keywords
    @page_title = this_blog.statuses_title_template.to_title(@statuses, this_blog, params)
    @description = this_blog.statuses_desc_template.to_title(@statuses, this_blog, params)    
  end
  
  def show
    if @status = Status.published.find_by_permalink(CGI.escape(params[:permalink]))
      @keywords = this_blog.meta_keywords
      @page_title = this_blog.status_title_template.to_title(@status, this_blog, params)
      @description = this_blog.status_desc_template.to_title(@status, this_blog, params)    
      @canonical_url = @status.permalink_url
      
      if @status.in_reply_to_message and !@status.in_reply_to_message.empty?
        @reply = JSON.parse(@status.in_reply_to_message)
      end
      
    else
      render "errors/404", :status => 404
    end
  end
end