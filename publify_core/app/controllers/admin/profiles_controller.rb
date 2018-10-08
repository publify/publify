# frozen_string_literal: true

# This controller handles updating your own user data.
class Admin::ProfilesController < Admin::BaseController
  before_action :set_user, only: [:index, :update]

  def index; end

  def update
    @user.resource = upload_avatar if params[:user][:filename]

    if @user.update(update_params)
      redirect_to admin_profiles_url, notice: I18n.t('admin.profiles.index.success')
    else
      render :index
    end
  end

  private

  def upload_avatar
    file = params[:user][:filename]

    mime = if file.content_type
             file.content_type.chomp
           else
             'text/plain'
           end

    Resource.create(upload: file, mime: mime, created_at: Time.zone.now)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:login, :password, :password_confirmation,
                                 :email, :firstname, :lastname, :nickname,
                                 :name, :notify_via_email,
                                 :notify_on_new_articles, :notify_on_comments,
                                 :text_filter_id, :state,
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
