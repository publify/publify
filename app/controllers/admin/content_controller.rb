require 'base64'

module Admin; end

class Admin::ContentController < Admin::BaseController
  layout 'administration'

  cache_sweeper :blog_sweeper

  def auto_complete_for_article_keywords
    @items = Tag.select(:display_name).order(:display_name).map { |t| t.display_name }
    render inline: '<%= @items %>'
  end

  def index
    @search = params[:search] ? params[:search] : {}
    @articles = Article.search_with(@search)
    @articles = @articles.where('parent_id IS NULL')
    @articles = @articles.page(params[:page]).per(this_blog.admin_display_elements)

    if request.xhr?
      respond_to do |format|
        format.js {}
      end
    else
      @article = Article.new(params[:article])
    end
  end

  def new
    @article = Article::Factory.new(this_blog, current_user).default
    load_resources
  end

  def create
    article_factory = Article::Factory.new(this_blog, current_user)
    @article = article_factory.get_or_build_from(params[:article][:id])

    update_article_attributes
    @article.author = current_user

    if @article.save
      if @article.draft?
        flash[:success] = I18n.t('admin.content.create.success.draft')
      else
        flash[:success] = I18n.t('admin.content.create.success.published')
      end
      redirect_to action: 'edit', id: @article
    else
      @article.keywords = Tag.collection_to_string @article.tags
      load_resources
      render 'new'
    end
  end

  def edit
    return unless access_granted?(params[:id])
    @article = Article.find(params[:id])
    @article.text_filter ||= current_user.default_text_filter
    @article.keywords = Tag.collection_to_string @article.tags
    load_resources
  end

  def update
    return unless access_granted?(params[:id])
    id = params[:article][:id] || params[:id]
    @article = Article.find(id)

    unless params[:draft]
      if @article.parent_id.present?
        @article = Article.find(@article.parent_id)
      end
    end

    update_article_attributes

    if @article.save
      if !params[:draft]
        Article.where(parent_id: @article.id).map(&:destroy)
      end

      # When trying to use the standard carrierwave methods to remove attachments, something
      # is causing it to try to remove items from the cdn twice.  The following approach works
      # around this by removing the image from the cdn manually, then updating the column without
      # triggering any callbacks (which is where the extra cdn call seems to come from).
      if params[:remove_hero_image]
        @article.hero_image.remove!
        @article.update_column(:hero_image, nil)
      end

      if params[:remove_teaser_image]
        @article.teaser_image.remove!
        @article.update_column(:teaser_image, nil)
      end

      if @article.draft?
        flash[:success] = I18n.t('admin.content.update.success.draft')
      elsif @article.withdrawn?
        flash[:success] = I18n.t('admin.content.update.success.withdrawn')
      else
        if (@article.previous_changes['state'] || []).include?('draft')
          flash[:success] = I18n.t('admin.content.update.success.published')
        elsif (@article.previous_changes['state'] || []).include?('withdrawn')
          flash[:success] = I18n.t('admin.content.update.success.published_withdrawn')
        else
          flash[:success] = I18n.t('admin.content.update.success.published_updated')
        end
      end
      redirect_to action: 'edit', id: @article
    else
      @article.keywords = Tag.collection_to_string @article.tags
      load_resources
      render 'edit'
    end
  end

  def destroy
    destroy_a(Article)
  end

  protected

  attr_accessor :resources, :resource

  private

  def load_resources
    @post_types = PostType.all
    @images = Resource.images_by_created_at.page(params[:page]).per(10)
    @resources = Resource.without_images_by_filename
  end

  def access_granted?(article_id)
    article = Article.find(article_id)
    if article.access_by? current_user
      return true
    else
      flash[:error] = I18n.t('admin.content.access_granted.error')
      redirect_to action: 'index'
      return false
    end
  end

  def update_article_attributes
    # Setting the state triggers an override of #published_at= so needs to be be done early
    @article.state = if params[:draft]
                       'draft'
                     elsif params[:withdraw]
                       'withdrawn'
                     else
                       'published'
                     end
    @article.attributes = update_params
    @article.published_at = parse_date_time params[:article][:published_at]
    @article.save_attachments!(params[:attachments])
    @article.text_filter ||= current_user.default_text_filter
  end

  def update_params
    params.require(:article).except(:id).permit!
  end
end
