class Admin::TagsController < Admin::BaseController
  before_action :set_tag, only: [:edit, :update, :destroy]
  cache_sweeper :blog_sweeper

  def index
    @tags = Tag.order('display_name').page(params[:page]).per(this_blog.admin_display_elements)
    @tag = Tag.new
  end

  def edit
    @tags = Tag.order('display_name').page(params[:page]).per(this_blog.admin_display_elements)
  end

  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      redirect_to admin_tags_url, notice: 'Tag was successfully created.'
    else
      render :index
    end
  end

  def update
    old_name = @tag.name
    if @tag.update(tag_params)
      Redirect.create(from_path: "/tag/#{old_name}", to_path: @tag.permalink_url(nil, true))
      redirect_to admin_tags_url, notice: I18n.t('admin.tags.edit.success')
    else
      render :edit
    end
  end

  def destroy
    destroy_a(Tag)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tag
    @tag = Tag.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tag_params
    params.require(:tag).permit(:display_name)
  end
end
