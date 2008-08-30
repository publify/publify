class Admin::UsersController < Admin::BaseController

  def list
    index
    render :action => 'index' if current_user.profile.label == 'admin'
  end

  def index
    if current_user.profile.label == 'admin'
      @users = User.find :all
    else
      redirect_to :action => 'edit'
    end
  end

  def new
    @user = User.new(params[:user])
    setup_profiles
    if request.post? and @user.save
      flash[:notice] = _('User was successfully created.')
      redirect_to :action => 'list'
    end
  end

  def edit
    if current_user.profile.label == 'admin'
      @user = User.find_by_id(params[:id])
    else
      if params[:id] and params[:id].to_i != current_user[:id]
        flash[:error] = _("Error, you are not allowed to perform this action")
      end
      @user = User.find_by_id(current_user.id)
    end
    setup_profiles
    @user.attributes = params[:user]
    if request.post? and @user.save
      flash[:notice] = _('User was successfully updated.')
      redirect_to :action => 'list'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if request.post?
      @user.destroy if User.count > 1
      redirect_to :action => 'list'
    end
  end

  def setup_profiles
    @profiles = Profile.find(:all, :order => 'id')
  end
end
