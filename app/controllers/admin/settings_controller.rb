class Admin::SettingsController < Admin::BaseController
  def index
    if this_blog.base_url.blank?
      this_blog.base_url = blog_base_url
    end
    
    if request.post?
      self.update
    end
  end
  
  def read
    if request.post?
      self.update
    end    
  end
  
  def write
    if request.post?
      self.update
    end    
  end

  def feedback
    if request.post?
      self.update
    end    
  end

  def spam
    if request.post?
      self.update
    end    
  end
  
  def podcast
    if request.post?
      self.update
    end    
  end
  
  def redirect
    flash[:notice] = "Please review and save the settings before continuing"
    redirect_to :action => "index"
  end

  def update
    if request.post?
      Blog.transaction do
        params[:setting].each { |k,v| this_blog.send("#{k.to_s}=", v) }
        this_blog.save
        flash[:notice] = _('config updated.')
      end
      redirect_to :action => 'index'
    end
  end
  
end