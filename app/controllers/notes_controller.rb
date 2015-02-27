class NotesController < ContentController
  require 'json'

  layout :theme_layout
  cache_sweeper :blog_sweeper
  caches_page :index, :show, if: proc { |c| c.request.query_string == '' }

  after_action :set_blog_infos

  def index
    @notes = Note.published.page(params[:page]).per(this_blog.limit_article_display)

    if @notes.empty?
      @message = I18n.t('errors.no_notes_found')
      render 'notes/error', status: 200
    end
  end

  def show
    @note = Note.published.find_by_permalink(CGI.escape(params[:permalink]))

    return render 'errors/404', status: 404 unless @note

    @canonical_url = @note.permalink_url

    if @note.in_reply_to_message.present?
      @reply = JSON.parse(@note.in_reply_to_message)
      render :show_in_reply
    end
  end

  private

  def set_blog_infos
    @keywords = this_blog.meta_keywords
    @page_title = this_blog.statuses_title_template.to_title(@notes, this_blog, params)
    @description = this_blog.statuses_desc_template.to_title(@notes, this_blog, params)
  end
end
