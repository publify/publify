class Admin::UsersController < Admin::BaseController

  def index
    list
    render :action => 'list'
  end

  def list
    @users = User.find :all
  end

  def show
    @user = User.find(params[:id], :include => [ :articles ])
    @articles = @user.articles
  end

  def new
    @user = User.new(params[:user])
    setup_profiles
    if request.post? and @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to :action => 'list'
    end
  end

  def edit
    @user = User.find_by_id(params[:id])
    setup_profiles
    @user.attributes = params[:user]
    if request.post? and @user.save
      flash[:notice] = 'User was successfully updated.'
      redirect_to :action => 'show', :id => @user.id
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
