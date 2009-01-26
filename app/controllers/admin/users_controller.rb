class Admin::UsersController < Admin::BaseController

  cache_sweeper :blog_sweeper

  def index
    if current_user.admin?
      @users = User.paginate :page => params[:page], :order => 'login asc', :per_page => 10
    else
      redirect_to :action => 'edit'
    end
  end

  def new
    @user = User.new(params[:user])
    @user.text_filter = TextFilter.find_by_name(this_blog.text_filter)
    setup_profiles
    if request.post? and @user.save
      flash[:notice] = _('User was successfully created.')
      redirect_to :action => 'index'
    end
  end

  def edit
    if current_user.admin?
      @user = User.find_by_id(params[:id])
    else
      if params[:id] and params[:id].to_i != current_user[:id]
        flash[:error] = _("Error, you are not allowed to perform this action")
      end
    end
    if @user.nil?
      @user = current_user
    end
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
