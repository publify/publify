class Admin::RedirectsController < Admin::BaseController
  before_action :set_redirect_type, only: [:edit, :update, :destroy]
  
  def index
    @redirects = Redirect.where('origin is null').order('id desc').page(params[:page]).per(this_blog.admin_display_elements)
    @redirect = Redirect.new
  end

  def new
    redirect_to admin_redirects_url
  end

  def edit
    @redirects = Redirect.where('origin is null').order('id desc').page(params[:page]).per(this_blog.admin_display_elements)
  end

  def create
    @redirect = Redirect.new(redirect_params)

    if @redirect.save
      redirect_to admin_redirects_url, notice: 'Redirect was successfully created.'
    else
      render :index
    end
  end

  def update
    if @redirect.update(redirect_params)
      redirect_to admin_redirects_url, notice: 'Redirect was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @redirect.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private

  def new_or_edit
    @redirects = Redirect.where('origin is null').order('id desc').page(params[:page]).per(this_blog.admin_display_elements)

    @redirect = case params[:id]
    when nil
      Redirect.new
    else
      Redirect.find(params[:id])
    end

    @redirect.attributes = params[:redirect].permit! if params[:redirect]
    if @redirect.from_path.nil? || @redirect.from_path.empty?
      @redirect.from_path = @redirect.shorten
    end
    if request.post?
      save_a(@redirect, 'redirection')
    else
      render 'new'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_redirect_type
    @redirect_type = Redirect.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def redirect_params
    params.require(:redirect).permit(:from_path, :to_path)
  end
end
