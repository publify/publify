class StatusesController < ContentController
  layout :theme_layout
  
  def index
    @statuses = Status.page(params[:page]).per(this_blog.limit_article_display)
    @keywords = this_blog.meta_keywords
    @page_title = this_blog.statuses_title_template.to_title(@statuses, this_blog, params)
    @description = this_blog.statuses_desc_template.to_title(@statuses, this_blog, params)    
  end
  
  def show
    if @status = Status.find_by_permalink(CGI.escape(params[:permalink]))
      @keywords = this_blog.meta_keywords
      @page_title = this_blog.status_title_template.to_title(@status, this_blog, params)
      @description = this_blog.status_desc_template.to_title(@status, this_blog, params)    
      @canonical_url = @status.permalink_url
    else
      render "errors/404", :status => 404
    end
  end
end