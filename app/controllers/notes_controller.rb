class NotesController < ContentController
  require 'json'
  
  layout :theme_layout
  cache_sweeper :blog_sweeper
  caches_page :index, :show, :if => Proc.new {|c|
    c.request.query_string == ''
  }
  
  def index
    @notes = Note.published.page(params[:page]).per(this_blog.limit_article_display)
    @keywords = this_blog.meta_keywords
    @page_title = this_blog.statuses_title_template.to_title(@notes, this_blog, params)
    @description = this_blog.statuses_desc_template.to_title(@notes, this_blog, params)    
    return error! if @notes.empty?
  end
  
  def show
    if @note = Note.published.find_by_permalink(CGI.escape(params[:permalink]))
      @keywords = this_blog.meta_keywords
      @page_title = this_blog.status_title_template.to_title(@note, this_blog, params)
      @description = this_blog.status_desc_template.to_title(@note, this_blog, params)    
      @canonical_url = @note.permalink_url
      
      if @note.in_reply_to_message and !@note.in_reply_to_message.empty?
        @reply = JSON.parse(@note.in_reply_to_message)
      end
      
    else
      render "errors/404", :status => 404
    end
  end
  
  def error!
    @message = I18n.t("errors.no_notes_found")
    render 'notes/error', status: 200
  end
  
end