require 'base64'

module Admin; end

class Admin::ContentController < Admin::BaseController
  layout :get_layout

  cache_sweeper :blog_sweeper

  def auto_complete_for_article_keywords
    @items = Tag.find_with_char params[:article][:keywords].strip
    render inline: "<%= raw auto_complete_result @items, 'name' %>"
  end

  def index
    @search = params[:search] ? params[:search] : {}
    @articles = Article.search_with(@search).page(params[:page]).per(this_blog.admin_display_elements)

    if request.xhr?
      render partial: 'article_list', locals: { articles: @articles }
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

    if @article.save
      update_categories_for_article
      set_the_flash
      redirect_to action: 'index'
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

    if params[:article][:draft]
      get_fresh_or_existing_draft_for_article
    else
      if not @article.parent_id.nil?
        @article = Article.find(@article.parent_id)
      end
    end

    update_article_attributes

    if @article.save
      unless @article.draft
        Article.where(parent_id: @article.id).map(&:destroy)
      end
      update_categories_for_article
      set_the_flash
      redirect_to :action => 'index'
    else
      @article.keywords = Tag.collection_to_string @article.tags
      load_resources
      render 'edit'
    end
  end

  def destroy
    destroy_a(Article)
  end

  def autosave
    id = params[:article][:id] || params[:id]

    article_factory = Article::Factory.new(this_blog, current_user)
    @article = article_factory.get_or_build_from(id)

    get_fresh_or_existing_draft_for_article

    @article.attributes = params[:article]

    @article.published = false
    @article.set_author(current_user)
    @article.save_attachments!(params[:attachments])
    @article.state = "draft" unless @article.state == "withdrawn"
    @article.text_filter ||= current_user.default_text_filter

    if @article.title.blank?
      lastid = Article.find(:first, :order => 'id DESC').id
      @article.title = "Draft article " + lastid.to_s
    end

    if @article.save
      gflash :success => _("Article was successfully saved")
      @must_update_calendar = (params[:article][:published_at] and params[:article][:published_at].to_time.to_i < Time.now.to_time.to_i and @article.parent_id.nil?)
      respond_to do |format|
        format.js
      end
    end
  end

  protected

  def get_fresh_or_existing_draft_for_article
    if @article.published and @article.id
      parent_id = @article.id
      @article = Article.drafts.child_of(parent_id).first || Article.new
      @article.allow_comments = this_blog.default_allow_comments
      @article.allow_pings    = this_blog.default_allow_pings
      @article.parent_id      = parent_id
    end
  end

  attr_accessor :resources, :categories, :resource, :category

  def set_the_flash
    case params[:action]
    when 'create'
      flash[:notice] = _('Article was successfully created')
    when 'update'
      flash[:notice] = _('Article was successfully updated.')
    else
      raise "I don't know how to tidy up action: #{params[:action]}"
    end
  end

  private

  def load_resources
    @post_types = PostType.find(:all)
    @images = Resource.images_by_created_at.page(params[:page]).per(10)
    @resources = Resource.without_images_by_filename
    @macros = TextFilter.macro_filters
  end

  def update_categories_for_article
    @article.categorizations.clear
    if params[:categories]
      Category.find(params[:categories]).each do |cat|
        @article.categories << cat
      end
    end
  end

  def access_granted?(article_id)
    article = Article.find(article_id)
    if article.access_by? current_user
      return true
    else
      flash[:error] = _("Error, you are not allowed to perform this action")
      redirect_to action: 'index'
      return false
    end
  end

  def update_article_attributes
    @article.attributes = params[:article]
    @article.published_at = parse_date_time params[:article][:published_at]
    @article.set_author(current_user)
    @article.save_attachments!(params[:attachments])
    @article.state = "draft" if @article.draft
    @article.text_filter ||= current_user.default_text_filter
  end
  
  def get_layout
    case action_name
    when "new", "edit", "create"
      "editor"
    when "show", "autosave"
      nil
    else
      "administration"
    end
  end
end
