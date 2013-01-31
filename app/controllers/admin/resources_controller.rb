require 'fog'

class Admin::ResourcesController < Admin::BaseController
  cache_sweeper :blog_sweeper

  def upload
    file = params[:upload][:filename]

    unless file.content_type
      mime = 'text/plain'
    else
      mime = file.content_type.chomp
    end
    @up = Resource.create(:upload => file, :mime => mime, :created_at => Time.now)

    flash[:notice] = _("File successfully uploaded")
    redirect_to :action => "index"
  end

  def index
    @r = Resource.new
    @resources = Resource.order('created_at DESC').page(params[:page]).per(this_blog.admin_display_elements)
  end

  def get_thumbnails
    position = params[:position].to_i
    @resources = Resource.without_images.by_created_at.limit(10).offset(position)

    render 'get_thumbnails', :layout => false
  end

  def destroy
    begin
      @record = Resource.find(params[:id])
      mime = @record.mime
      return(render 'admin/shared/destroy') unless request.post?

      @record.destroy
      redirect_to :action => 'index'
    rescue
      raise
    end
  end
end
