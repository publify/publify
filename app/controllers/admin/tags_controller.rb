class Admin::TagsController < Admin::BaseController
  
  def index
    list
    render :action => 'list'
  end
  
  def list
    if params[:order] and params[:order] =~ /\A(?:name|display_name|article_counter)\Z/
      if params[:sense] and params[:sense] == 'desc'
        order = params[:order] + " asc"
      else
        order = params[:order] + " desc"
      end
    else
      order = 'display_name ASC'
    end
    
    count = Tag.count
    @tags_pages = Paginator.new(self, count, 20, params[:id])
    @tags = Tag.find_all_with_article_counters(20 , order, @tags_pages.current.offset)

  end
  
  def edit
    @tag = Tag.find(params[:id])
    @tag.attributes = params[:tag]

    if request.post? and @tag.save
      flash[:notice] = 'Tag was successfully updated.'
      redirect_to :action => 'list'
    end
  end
    
  def destroy
    @tag = Tag.find(params[:id])
    if request.post?
      @tag.destroy
      redirect_to :action => 'list'
    end
  end
  
end