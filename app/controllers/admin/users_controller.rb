class Admin::UsersController < Admin::BaseController
  
  def index
    list
    render_action 'list'
  end

  def list
    @users = User.find_all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new(params[:user])
    if request.post? and @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to :action => 'list'
    end      
  end

  def edit
    @user = User.find(params[:id])
    @user.attributes = params[:user]
    if request.post? and @user.save
      flash[:notice] = 'User was successfully updated.'
      redirect_to :action => 'show', :id => @user.id
    end      
    @user.password = @user.password_confirmation =  ''
  end

  def destroy
    @user = User.find(params[:id])
    if request.post?
      @user.destroy if User.count > 1
      redirect_to :action => 'list'
    end
  end
  
end
