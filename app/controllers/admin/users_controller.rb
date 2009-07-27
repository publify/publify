class Admin::UsersController < Admin::BaseController

  cache_sweeper :blog_sweeper

  def index
    @users = User.paginate :page => params[:page], :order => 'login asc', :per_page => this_blog.admin_display_elements
  end

  def new
    @user = User.new(params[:user])
    @user.text_filter = TextFilter.find_by_name(this_blog.text_filter)
    setup_profiles
    @user.name = @user.login
    if request.post? and @user.save
      flash[:notice] = _('User was successfully created.')
      redirect_to :action => 'index'
    end
  end

  def edit
    @user = params[:id] ? User.find_by_id(params[:id]) : current_user

    setup_profiles
    @user.attributes = params[:user]
    if request.post? and @user.save
      if @user.id = current_user.id
        current_user = @user
      end
      flash[:notice] = _('User was successfully updated.')
      redirect_to :action => 'index'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if request.post?
      @user.destroy if User.count > 1
      redirect_to :action => 'index'
    end
  end

  def setup_profiles
    @profiles = Profile.find(:all, :order => 'id')
  end
end
