class Admin::ResourcesController < Admin::BaseController
  cache_sweeper :blog_sweeper

  def upload
    if !params[:upload].blank?
      file = params[:upload][:filename]

      mime = if file.content_type
               file.content_type.chomp
             else
               'text/plain'
             end

      @up = Resource.create(upload: file, mime: mime, created_at: Time.now, blog: this_blog)
      flash[:success] = I18n.t('admin.resources.upload.success')
    else
      flash[:warning] = I18n.t('admin.resources.upload.warning')
    end

    redirect_to admin_resources_url
  end

  def index
    @r = Resource.new
    @resources = Resource.order('created_at DESC').page(params[:page]).per(this_blog.admin_display_elements)
  end

  def destroy
    @record = Resource.find(params[:id])
    @record.destroy
    flash[:notice] = I18n.t('admin.resources.destroy.notice')
    redirect_to admin_resources_url
  end
end
