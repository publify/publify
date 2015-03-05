class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:edit, :update, :destroy]
  cache_sweeper :blog_sweeper

  def index
    @users = User.order('login asc').page(params[:page]).per(this_blog.admin_display_elements)
  end

  def new
    @user = User.new
    @user.text_filter = TextFilter.find_by_name(this_blog.text_filter)
    setup_profiles
  end

  def edit
    @user = params[:id] ? User.find_by_id(params[:id]) : current_user
    setup_profiles
  end

  def create
    @user = User.new(user_params)
    @user.name = @user.login
    if @user.save
      redirect_to admin_users_url, notice: I18n.t('admin.users.new.success')
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_url, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy if User.where('profile_id = ? and id != ?', Profile.find_by_label('admin'), @user.id).count > 1
    redirect_to admin_users_url
  end

  private

  def setup_profiles
    @profiles = Profile.order('id')
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:login, :password, :password_confirmation, :email, :firstname, :lastname, :nickname, :display_name, :notify_via_email, :notify_on_new_articles, :notify_on_comments, :profile_id, :text_filter_id, :state, :twitter_account, :twitter_oauth_token, :twitter_oauth_token_secret, :description, :url, :msn, :yahoo, :jabber, :aim, :twitter)
  end
end
