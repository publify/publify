require 'fog'

class Admin::ProfilesController < Admin::BaseController
  def index
    @user = current_user
    @profiles = Profile.find(:all, :order => 'id')
    @user.attributes = params[:user]
    if request.post?
      if params[:user][:filename]
        avatar = upload_avatar 
        @user.avatar = avatar.upload.avatar.url
        @user.thumb_avatar = avatar.upload.thumb.url
        @user.medium_avatar = avatar.upload.medium.url
        @user.large_avatar = avatar.upload.url
      end
      
      if @user.save
        current_user = @user
        flash[:notice] = _('User was successfully updated.')
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
