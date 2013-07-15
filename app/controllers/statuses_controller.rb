class StatusesController < ContentController
  layout :theme_layout
  
  def index
    @statuses = Status.page(params[:page]).per(this_blog.limit_article_display)
  end
  
  def show
    if @status = Status.find_by_permalink(CGI.escape(params[:permalink]))
      @page_title = @status.body
      @description = this_blog.meta_description
      @keywords = this_blog.meta_keywords
      @canonical_url = @status.permalink_url
    else
      render "errors/404", :status => 404
    end
  end
end