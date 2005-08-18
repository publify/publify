class Admin::ResourcesController < Admin::BaseController
  upload_status_for :file_upload, :status => :upload_status
  
  def upload
    begin
      case request.method
        when :post
          file = params[:upload][:filename]
          @up = Resource.create(:filename => file.original_filename, :mime => file.content_type.chomp, :created_at => Time.now)

          @up.write_to_disk(file)
    
          @message = 'File uploaded: '+file.size.to_s
          finish_upload_status "'#{@message}'"
      end
    rescue
      @message = "'Unable to upload #{file.original_filename}'"
      @up.destroy unless @up.nil?
      raise
    end
  end

  def upload_status
    render :inline => "<%= upload_progress.completed_percent rescue 0 %> % complete", :layout => false
  end

  def list
    @resources_pages, @resources = paginate :resource, :per_page => 15, :order_by => "created_at DESC", :parameter => 'id'
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
