class Admin::PostTypesController < Admin::BaseController
  before_action :set_post_type, only: [:edit, :update, :destroy]
  cache_sweeper :blog_sweeper

  def index
    @post_types = PostType.all
    @post_type = PostType.new
  end

  def edit
    @post_types = PostType.all
  end

  def create
    @post_type = PostType.new(post_type_params)

    if @post_type.save
      redirect_to admin_post_types_url, notice: 'Post type was successfully created.'
    else
      render :index
    end
  end

  def update
    if @post_type.update(post_type_params)
      redirect_to admin_post_types_url, notice: 'Post type was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    # Reset all Articles from the PostType we're destroying to the default PostType
    # Wrap it in a transaction for safety
    @post_type.transaction do
      Article.where('post_type = ?', @post_type.permalink).each do |article|
        article.post_type = 'read'
        article.save
      end
      @post_type.destroy
    end
    redirect_to admin_post_types_url, notice: 'Post was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post_type
    @post_type = PostType.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_type_params
    params.require(:post_type).permit(:name, :description)
  end
end
