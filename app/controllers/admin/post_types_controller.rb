class Admin::PostTypesController < Admin::BaseController
  cache_sweeper :blog_sweeper

  def index; redirect_to :action => 'new' ; end
  def new; new_or_edit ; end
  def edit; new_or_edit;  end

  def destroy
    @record = PostType.find(params[:id])
    return(render 'admin/shared/destroy') unless request.post?

    Article.where("post_type = ?", @record.permalink).each do |article|
      article.post_type = 'read'
      article.save
    end
    @record.destroy
    redirect_to :action => 'index'
  end

  private

  def new_or_edit
    @post_types = PostType.all
    @post_type = PostType.where(id: params[:id]).first
    @post_type ||= PostType.new
    @post_type.attributes = params[:post_type].permit! if params[:post_type]
    if request.post?
      save_a(@post_type, 'Post Type')
    else
      render 'new'
    end
  end

end
