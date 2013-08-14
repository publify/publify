module Admin; end

class Admin::StatusesController < Admin::ContentController
  layout "administration"

  def index; redirect_to :action => 'new' ; end
  def new; new_or_edit; end
  def edit; new_or_edit; end

  def destroy
    destroy_a(Status)
  end

  private
  def get_or_build_status
    id = params[:id]
    return Status.find(id) if id

    Status.new do |status|
      status.text_filter = current_user.default_text_filter
      status.published = true
      status.published_at = Time.now
      status.push_to_twitter = true
    end
  end

  def update_status_attributes
    @status.attributes = params[:status]
    @status.published_at = parse_date_time params[:status][:published_at]
    @status.set_author(current_user)
    @status.text_filter ||= current_user.default_text_filter
  end

  def new_or_edit
    @statuses = Status.page(params[:page]).per(this_blog.limit_article_display)
    @status = get_or_build_status

    if request.post?
      update_status_attributes

      message = "created"
      if @status.id
        unless @status.access_by?(current_user)
          flash[:error] = _("Error, you are not allowed to perform this action")
          return(redirect_to :action => 'new')
        end

        message = "updated"
      end

      if @status.save
        @status.send_to_twitter(current_user) if params[:status][:push_to_twitter] and @status.twitter_id.nil? or @status.twitter_id.empty?
        flash[:notice] = _("Status was successfully %s.", message)
        redirect_to :action => 'new'
      end
      return
    end

    render 'new'
  end

end
