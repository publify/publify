class Admin::AdvancedController < Admin::BaseController
  def index
    if this_blog.base_url.blank?
      this_blog.base_url = blog_base_url
    end
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

  private
end
