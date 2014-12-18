require 'fog'

class Admin::ProfilesController < Admin::BaseController
  def index
    @user = current_user
    @profiles = Profile.order('id')
    @user.attributes = params[:user].permit! if params[:user]
    if request.post?
      if params[:user][:filename]
        @user.resource = upload_avatar
      end
      
      if @user.save
        current_user = @user
        flash[:success] = I18n.t('admin.profiles.index.success')
        redirect_to '/admin/profiles'
      end
    end
  end

  private
  
  def upload_avatar
    file = params[:user][:filename]

    unless file.content_type
      mime = 'text/plain'
    else
      mime = file.content_type.chomp
    end

    Resource.create(:upload => file, :mime => mime, :created_at => Time.now)
  end
  

end
