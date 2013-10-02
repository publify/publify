module Admin; end

class Admin::NotesController < Admin::BaseController
  layout "administration"
  cache_sweeper :blog_sweeper

  def index; redirect_to :action => 'new' ; end
  def new; new_or_edit; end
  def edit; new_or_edit; end

  def destroy
    destroy_a(Note)
  end

  private
  def get_or_build_status
    id = params[:id]
    return Note.find(id) if id

    Note.new do |note|
      note.text_filter = current_user.default_text_filter
      note.published = true
      note.published_at = Time.now
    end
  end

  def update_status_attributes
    @note.attributes = params[:note]
    @note.published_at = parse_date_time params[:note][:published_at]
    @note.set_author(current_user)
    @note.text_filter ||= current_user.default_text_filter
  end

  def new_or_edit
    @notes = Note.page(params[:page]).per(this_blog.limit_article_display)
    @note = get_or_build_status

    if request.post?
      update_status_attributes

      message = "created"
      if @note.id
        unless @note.access_by?(current_user)
          flash[:error] = _("Error, you are not allowed to perform this action")
          return(redirect_to :action => 'new')
        end
        message = "updated"
      end

      if @note.save
        flash[:notice] = _("Note was successfully %s.", message)
        if params[:push_to_twitter] && @note.twitter_id.blank?
          unless @note.send_to_twitter
            flash[:notice] = nil
            flash[:error] = _("Oooops something wrong happened")
          end
        end
        redirect_to action: 'new'
      end
      return
    end
    render 'new'
  end

end
