class Admin::TagsController < Admin::BaseController
  
  cache_sweeper :blog_sweeper

  def index
    if params[:order] and params[:order] =~ /\A(?:name|display_name|article_counter)\Z/
      if params[:sense] and params[:sense] == 'desc'
        order = params[:order] + " asc"
      else
        order = params[:order] + " desc"
      end
    else
      order = 'display_name ASC'
    end

    @tags = Tag.paginate(:page => params[:page], :order => :display_name, :per_page => 10)
  end
  
  def edit
    @tag = Tag.find(params[:id])
    @tag.attributes = params[:tag]

    if request.post? and @tag.save
      flash[:notice] = _('Tag was successfully updated.')
      redirect_to :action => 'index'
    end
  end
    
  def destroy
    @tag = Tag.find(params[:id])
    if request.post?
      @tag.destroy
      redirect_to :action => 'index'
    end
  end
  
end
