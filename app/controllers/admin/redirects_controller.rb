class Admin::RedirectsController < Admin::BaseController
  before_action :set_redirect, only: [:edit, :update, :destroy]

  def index
    @redirects = Redirect.where('origin is null').order('id desc').page(params[:page]).per(this_blog.admin_display_elements)
    @redirect = Redirect.new
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
    redirect_to admin_redirects_url, notice: I18n.t('admin.redirects.destroy.success')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_redirect
    @redirect = Redirect.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def redirect_params
    params.require(:redirect).permit(:from_path, :to_path)
  end
end
