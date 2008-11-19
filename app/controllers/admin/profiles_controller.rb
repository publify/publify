class Admin::ProfilesController < Admin::BaseController

  cache_sweeper :blog_sweeper

  def index

  end

  def new
    @profile = Profile.new(params[:profile])
    if request.post? and @profile.save
      flash[:notice] = _('Profile was successfully created.')
      redirect_to :action => 'index'
    end
  end

  def edit
    @profile = Profile.find(params[:id])
    @profile.attributes = params[:profile]
    if request.post? and @profile.save
      flash[:notice] = _('Profile was successfully updated.')
      redirect_to :action => 'index'
    end
  end

  def destroy
    @profile = Profile.find(params[:id])
    if request.post?
      @profile.destroy if Profile.count > 1
      redirect_to :action => 'index'
    end
  end
end
