class Admin::NotesController < Admin::BaseController
  layout 'administration'
  cache_sweeper :blog_sweeper

  before_action :load_existing_notes, only: [:index, :edit]
  before_action :find_note, only: [:edit, :update, :show, :destroy]

  def index
    @note = Publisher.new(current_user).new_note
  end

  def show
    unless @note.access_by?(current_user)
      flash[:error] = I18n.t('admin.base.not_allowed')
      redirect_to action: 'index'
    end
  end

  def edit
  end

  def create
    note = Publisher.new(current_user).new_note

    note.published = true
    note.published_at = parse_date_time params[:note][:published_at]
    note.attributes = params[:note].permit!
    note.text_filter ||= current_user.default_text_filter
    note.published_at ||= Time.now
    if note.save
      if params[:push_to_twitter] && note.twitter_id.blank?
        unless note.send_to_twitter
          flash[:error] = I18n.t('errors.problem_sending_to_twitter')
          flash[:error] += " : #{note.errors.full_messages.join(' ')}"
        end
      end
      flash[:notice] = I18n.t('notice.note_successfully_created')
    else
      flash[:error] = note.errors.full_messages
    end
    redirect_to action: :index
  end

  def update
    @note.attributes = params[:note].permit!
    @note.save
    redirect_to action: :index
  end

  def destroy
    @note.destroy
    flash[:notice] = I18n.t('admin.base.successfully_deleted', name: 'note')
    redirect_to action: 'index'
  end

  private

  def load_existing_notes
    @notes = Note.page(params[:page]).per(this_blog.limit_article_display)
  end

  def find_note
    @note = Note.find(params[:id])
  end
end
