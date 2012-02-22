class Admin::TagsController < Admin::BaseController
  cache_sweeper :blog_sweeper

  def index
    @tags = Tag.order('display_name').page(params[:page]).per(this_blog.admin_display_elements)
  end

  def edit
    @tag = Tag.find(params[:id])
    @tag.attributes = params[:tag]

    if request.post?
      old_name = @tag.name

      if @tag.save
        # Create a redirection to ensure nothing nasty happens in the future
        Redirect.create(:from_path => "/tag/#{old_name}", :to_path => @tag.permalink_url(nil, true))

        flash[:notice] = _('Tag was successfully updated.')
        redirect_to :action => 'index'
      end
    end
  end

  def destroy
    @record = Tag.find(params[:id])
    return(render 'admin/shared/destroy') unless request.post?

    @record.destroy
    redirect_to :action => 'index'
  end

end
