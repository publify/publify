class Admin::ResourcesController < Admin::BaseController
  upload_status_for :file_upload, :status => :upload_status

  def upload
    begin
      case request.method
        when :post
          file = params[:upload][:filename]
          @up = Resource.create(:filename => file.original_filename, :mime => file.content_type.chomp, :created_at => Time.now)

          @up.write_to_disk(file)

          @message = _('File uploaded: ')+ file.size.to_s
          finish_upload_status "'#{@message}'"
      end
    rescue
      @message = "'" + _('Unable to upload') + " #{file.original_filename}'"
      @up.destroy unless @up.nil?
      raise
    end
  end

  def remove_itunes_metadata
    @resource = Resource.find(params[:id])
    @resource.itunes_metadata = false
    @resource.save(false)
    flash[:notice] = _('Metadata was successfully removed.')
    redirect_to :action => 'list'
  end

  def update
    @resource = Resource.find(params[:resource][:id])
    @resource.attributes = params[:resource]

    unless params[:itunes_category].nil?
      itunes_categories = params[:itunes_category]
      itunes_category_pre = Hash.new {|h, k| h[k] = [] }
      itunes_categories.each do |cat|
        cat_split = cat.split('-')
        itunes_category_pre[cat_split[0]] << cat_split[1] unless
        itunes_category_pre[cat_split[0]].include?(cat_split[0])
      end
      @resource.itunes_category = itunes_category_pre
    end
    if request.post? and @resource.save
      flash[:notice] = _('Metadata was successfully updated.')
    else
      flash[:error] = _('Not all metadata was defined correctly.')
      @resource.errors.each do |meta_key,val|
        flash[:error] << "<br />" + val
      end
    end
    redirect_to :action => 'list'
  end

  def set_mime
    @resource = Resource.find(params[:resource][:id])
    @resource.mime = params[:resource][:mime] unless params[:resource][:mime].empty?
    if request.post? and @resource.save
      flash[:notice] = _('Content Type was successfully updated.')
    else
      flash[:error] = _("Error occurred while updating Content Type.")
    end
    redirect_to :action => "list"
  end


  def upload_status
    render :inline => "<%= upload_progress.completed_percent rescue 0 %> % " + _("complete"), :layout => false
  end

  def list
    @r = Resource.new
    @itunes_category_list = @r.get_itunes_categories
    @resources_pages, @resources = paginate :resource, :per_page => 15, :order_by => "created_at DESC", :parameter => 'page'
  end

  def index
    list
    render :action => 'list'
  end

  def destroy
    begin
      @file = Resource.find(params[:id])
      case request.method
        when :post
          @file.destroy
          redirect_to :action => 'list'
      end
    rescue
      raise
    end
  end

  def new
  end
end
