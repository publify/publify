require 'base64'

module Admin; end

class Admin::ContentController < Admin::BaseController
  layout :get_layout

  cache_sweeper :blog_sweeper

  def index
    @search = params[:search] ? params[:search] : {}
    @articles = Article.search_with(@search).page(params[:page]).per(this_blog.admin_display_elements)

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

  def edit
    return unless access_granted?(params[:id])
    @article = Article.find(params[:id])
    @article.text_filter ||= current_user.default_text_filter
    @article.keywords = Tag.collection_to_string @article.tags
    load_resources
  end

  def create
    article_factory = Article::Factory.new(this_blog, current_user)
    @article = article_factory.get_or_build_from(params[:article][:id])

    update_article_attributes

    if @article.save
      flash[:success] = I18n.t('admin.content.create.success')
      redirect_to action: 'index'
    else
      @article.keywords = Tag.collection_to_string @article.tags
      load_resources
      render 'new'
    end
  end

  def update
    return unless access_granted?(params[:id])
    id = params[:article][:id] || params[:id]
    @article = Article.find(id)

    if params[:article][:draft]
      get_fresh_or_existing_draft_for_article
    else
      @article = Article.find(@article.parent_id) unless @article.parent_id.nil?
    end

    update_article_attributes

    if @article.save
      Article.where(parent_id: @article.id).map(&:destroy) unless @article.draft
      flash[:success] = I18n.t('admin.content.update.success')
      redirect_to action: 'index'
    else
      @article.keywords = Tag.collection_to_string @article.tags
      load_resources
      render 'edit'
    end
  end

  def destroy
    destroy_a(Article)
  end

  def auto_complete_for_article_keywords
    @items = Tag.select(:display_name).order(:display_name).map(&:display_name)
    render inline: '<%= @items %>'
  end

  def autosave
    return false unless request.xhr?

    id = params[:article][:id] || params[:id]

    article_factory = Article::Factory.new(this_blog, current_user)
    @article = article_factory.get_or_build_from(id)

    get_fresh_or_existing_draft_for_article

    @article.attributes = params[:article].permit!

    @article.published = false
    @article.author = current_user
    @article.save_attachments!(params[:attachments])
    @article.state = 'draft' unless @article.state == 'withdrawn'
    @article.text_filter ||= current_user.default_text_filter

    if @article.title.blank?
      lastid = Article.order('id desc').first.id
      @article.title = 'Draft article ' + lastid.to_s
    end

    if @article.save
      flash[:success] = I18n.t('admin.content.autosave.success')
      @must_update_calendar = (params[:article][:published_at] and params[:article][:published_at].to_time.to_i < Time.now.to_time.to_i and @article.parent_id.nil?)
      respond_to do |format|
        format.js
      end
    end
  end

  protected

  def get_fresh_or_existing_draft_for_article
    if @article.published && @article.id
      parent_id = @article.id
      @article = Article.drafts.child_of(parent_id).first || Article.new
      @article.allow_comments = this_blog.default_allow_comments
      @article.allow_pings    = this_blog.default_allow_pings
      @article.parent_id      = parent_id
    end
  end

  attr_accessor :resources, :resource

  private

  def load_resources
    @post_types = PostType.all
    @images = Resource.images_by_created_at.page(params[:page]).per(10)
    @resources = Resource.without_images_by_filename
    @macros = TextFilter.macro_filters
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
    @article.attributes = update_params
    @article.published_at = parse_date_time params[:article][:published_at]
    @article.author = current_user
    @article.save_attachments!(params[:attachments])
    @article.state = 'draft' if @article.draft
    @article.text_filter ||= current_user.default_text_filter
  end

  def update_params
    params.require(:article).except(:id).permit!
  end

  def get_layout
    case action_name
    when 'new', 'edit', 'create'
      'editor'
    when 'show', 'autosave'
      nil
    else
      'administration'
    end
  end
end
