class Admin::RedirectsController < Admin::BaseController
  def index; redirect_to :action => 'new' ; end
  def edit; new_or_edit;  end
  def new; new_or_edit;  end


  def destroy
    @record = Redirect.find(params[:id])
    return(render 'admin/shared/destroy') unless request.post?

    @record.destroy
    gflash :success
    redirect_to :action => 'index'
  end

  private
  def new_or_edit
    @redirects = Redirect.where("origin is null").order('id desc').page(params[:page]).per(this_blog.admin_display_elements)

    @redirect = case params[:id]
    when nil
      Redirect.new
    else
      Redirect.find(params[:id])
    end

    @redirect.attributes = params[:redirect]
      if  @redirect.from_path.nil? || @redirect.from_path.empty?
        @redirect.from_path = @redirect.shorten
      end
    if request.post?
      save_a(@redirect, 'redirection')
    else
      render 'new'
    end
  end

end
