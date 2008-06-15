class Admin::UsersController < Admin::BaseController

  def list
    index
    render :action => 'index'
  end

  def index
    @users = User.find :all
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
    @user = User.find_by_id(params[:id])
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
