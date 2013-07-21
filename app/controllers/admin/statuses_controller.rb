module Admin; end

class Admin::StatusesController < Admin::ContentController
  layout "administration"
  
  def index
    @statuses = Status.page(params[:page]).per(this_blog.limit_article_display)
  end
  
  def new; @status = get_or_build_status; end

  def edit; @status = get_or_build_status; end
  
  def create
    @status = Status.new
    update_status_attributes
    
    if @status.save
      flash[:notice] = _('Status was successfully created.')
      redirect_to :action => 'index'
    end
  end
  
  def update
    @status = Status.find(params[:id])
    
    unless @status.access_by?(current_user)
      flash[:error] = _("Error, you are not allowed to perform this action")
      return(redirect_to :action => 'index')
    end
    
    update_status_attributes
    
    if @status.save
      flash[:notice] = _('Status was successfully created.')
      redirect_to :action => 'index'
    end
    
  end
  
  def destroy
    @record = Status.find(params[:id])

    unless @record.access_by?(current_user)
      flash[:error] = _("Error, you are not allowed to perform this action")
      return(redirect_to :action => 'index')
    end

    return(render 'admin/shared/destroy') unless request.post?

    @record.destroy
    flash[:notice] = _("This status was deleted successfully")
    redirect_to :action => 'index'    
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
  
end
