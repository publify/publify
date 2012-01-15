class Admin::RedirectsController < Admin::BaseController
  layout 'administration'

  def index
    @redirects = Redirect.where("origin is null").order('created_at desc').page(params[:page]).per(this_blog.admin_display_elements)
  end

  def new
    new_or_edit
  end

  def edit
    new_or_edit
  end

  def destroy
    @redirect = Redirect.find(params[:id])

    if request.post?
      @redirect.destroy
      flash[:notice] = _('Redirection was successfully deleted.')
      redirect_to :action => 'index'
    end
  end

  private
  def new_or_edit
    @redirect = case params[:id]
    when nil
      Redirect.new
    else
      Redirect.find(params[:id])
    end

    @redirect.attributes = params[:redirect]
    if request.post?
      if @redirect.from_path.empty? || @redirect.from_path.nil?
        @redirect.from_path = @redirect.shorten
      end
      save_redirect
      return
    end
    render 'new'
  end

  def save_redirect
    if @redirect.save!
        flash[:notice] = _('Redirection was successfully saved.')
    else
      flash[:error] = _('Redirection could not be saved.')
    end
    redirect_to :action => 'index'
  end
end
