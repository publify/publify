class Admin::NotesController < Admin::BaseController
  layout "administration"
  cache_sweeper :blog_sweeper

  def index
    @notes = Note.page(params[:page]).per(this_blog.limit_article_display)
    @note = Note.new do |note|
      note.text_filter = current_user.default_text_filter
      note.published = true
      note.published_at = Time.now
      note.author = current_user
    end
  end

  def new
    redirect_to action: :index
  end

  def create
    note = Note.new
    note.text_filter = current_user.default_text_filter
    note.published = true
    note.attributes = params[:note]
    note.published_at = parse_date_time params[:note][:published_at]
    note.published_at ||= Time.now
    note.author = current_user
    note.text_filter ||= current_user.default_text_filter
    if note.save
      if params[:push_to_twitter] && note.twitter_id.blank?
        unless note.send_to_twitter
          flash[:error] = I18n.t("errors.problem_sending_to_twitter")
          flash[:error] += " : #{note.errors.full_messages.join(' ')}"
        end
      end
      flash[:notice] = I18n.t("notice.note_successfully_created")
    else
      flash[:error] = note.errors.full_messages
    end
    redirect_to action: :index
  end

  def edit
    @notes = Note.page(params[:page]).per(this_blog.limit_article_display)
    @note = Note.find(params[:id])
    render :index
  end

  def destroy
    note = Note.find(params[:id])
    note.destroy
    flash[:notice] = I18n.t("admin.base.successfully_deleted", name: 'note')
    redirect_to action: 'index'
  end

  def show
    @note = Note.find(params[:id])
    if @note.respond_to?(:access_by?) && !@note.access_by?(current_user)
      flash[:error] = I18n.t("admin.base.not_allowed")
      redirect_to action: 'index'
    end
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
    @note.author = current_user
    @note.text_filter ||= current_user.default_text_filter
  end

  def new_or_edit
    @notes = Note.page(params[:page]).per(this_blog.limit_article_display)
    @note = get_or_build_status

    if request.post?
      update_status_attributes

      if @note.id
        unless @note.access_by?(current_user)
          flash[:error] = I18n.t('errors.you_are_not_allowed')
          return(redirect_to action: 'new')
        end
        flash[:notice] = I18n.t("notice.note_successfully_updated")
      else
        flash[:notice] = I18n.t("notice.note_successfully_created")
      end

      if @note.save
        if params[:push_to_twitter] && @note.twitter_id.blank?
          unless @note.send_to_twitter
            flash[:error] = I18n.t("errors.problem_sending_to_twitter")
            flash[:error] += " : #{@note.errors.full_messages.join(' ')}"
          end
        end
        redirect_to action: 'new'
      end
      return
    end
    render 'new'
  end

end
