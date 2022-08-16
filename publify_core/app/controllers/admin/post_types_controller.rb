# frozen_string_literal: true

class Admin::PostTypesController < Admin::BaseController
  before_action :set_post_type, only: [:edit, :update, :destroy]

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
      flash[:notice] = I18n.t("admin.base.successfully_created",
                              name: PostType.model_name.human)
      redirect_to admin_post_types_url
    else
      render :index
    end
  end

  def update
    if @post_type.update(post_type_params)
      flash[:notice] = I18n.t("admin.base.successfully_updated",
                              name: PostType.model_name.human)
      redirect_to admin_post_types_url
    else
      render :edit
    end
  end

  def destroy
    # Reset all Articles from the PostType we're destroying to the default PostType
    # Wrap it in a transaction for safety
    @post_type.transaction do
      Article.where(post_type: @post_type.permalink).each do |article|
        article.post_type = "read"
        article.save
      end
      @post_type.destroy
    end
    flash[:notice] = I18n.t("admin.base.successfully_deleted",
                            name: PostType.model_name.human)
    redirect_to admin_post_types_url
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
