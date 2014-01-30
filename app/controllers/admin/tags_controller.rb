class Admin::TagsController < Admin::BaseController
  cache_sweeper :blog_sweeper

  def index; redirect_to action: 'new' ; end
  def new; new_or_edit; end
  def edit; new_or_edit; end

  def destroy
    destroy_a(Tag)
  end

  private

  def new_or_edit
    @tags = Tag.order('display_name').page(params[:page]).per(this_blog.admin_display_elements)
    @tag = case params[:id]
                when nil
                  Tag.new
                else
                  Tag.find(params[:id])
                end

    @tag.attributes = params[:tag]
    if request.post?
      old_name = @tag.name if @tag.id

      if @tag.save
        Redirect.create(:from_path => "/tag/#{old_name}", :to_path => @tag.permalink_url(nil, true))
        flash[:success] = I18n.t('admin.tags.edit.success')
      end
    end
    render 'new'
  end

end
