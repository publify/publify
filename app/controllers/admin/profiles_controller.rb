class Admin::ProfilesController < Admin::BaseController

  def index
    list
    render :action => 'list'
  end

  def list
    @profiles = Profile.find :all
  end

  def new
    @profile = Profile.new(params[:profile])
    if request.post? and @profile.save
      flash[:notice] = 'Profile was successfully created.'
      redirect_to :action => 'list'
    end
  end

  def edit
    @profile = Profile.find(params[:id])
    @profile.attributes = params[:profile]
    if request.post? and @profile.save
      flash[:notice] = 'Profile was successfully updated.'
      redirect_to :action => 'list'
    end
  end

  def destroy
    @profile = Profile.find(params[:id])
    if request.post?
      @profile.destroy if Profile.count > 1
      redirect_to :action => 'list'
    end
  end
end
