# frozen_string_literal: true

class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.order('login asc').page(params[:page]).per(this_blog.admin_display_elements)
  end

  def new
    @user = User.new
    @user.text_filter = TextFilter.find_by(name: this_blog.text_filter)
  end

  def edit
    @user = params[:id] ? User.find_by(id: params[:id]) : current_user
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
    if @user.update(update_params)
      redirect_to admin_users_url, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy if User.where('profile = ? and id != ?', User::ADMIN, @user.id).count > 1
    redirect_to admin_users_url
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:login, :password, :password_confirmation,
                                 :email, :firstname, :lastname, :nickname,
                                 :name, :notify_via_email,
                                 :notify_on_new_articles, :notify_on_comments,
                                 :profile, :text_filter_id, :state,
                                 :twitter_account, :twitter_oauth_token,
                                 :twitter_oauth_token_secret, :description,
                                 :url, :msn, :yahoo, :jabber, :aim, :twitter)
  end

  def update_params
    if user_params[:password].blank? && user_params[:password_confirmation].blank?
      user_params.except(:password_confirmation, :password)
    else
      user_params
    end
  end
end
