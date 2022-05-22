# frozen_string_literal: true

require "base64"

module Admin; end

class Admin::ContentController < Admin::BaseController
  def index
    @search = params[:search] || {}
    @articles = this_blog.articles.search_with(@search).page(params[:page]).
      per(this_blog.admin_display_elements)

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
    render layout: "editor"
  end

  def edit
    return unless access_granted?(params[:id])

    @article = Article.find(params[:id])
    @article.text_filter ||= default_text_filter
    @article.keywords = Tag.collection_to_string @article.tags
    load_resources
    render layout: "editor"
  end

  def create
    article_factory = Article::Factory.new(this_blog, current_user)
    @article = article_factory.get_or_build_from(params[:article][:id])

    update_article_attributes

    if @article.draft
      @article.state = "draft"
    elsif @article.draft?
      @article.publish!
    end

    if @article.save
      flash[:success] = I18n.t("admin.content.create.success")
      redirect_to action: "index"
    else
      @article.keywords = Tag.collection_to_string @article.tags
      load_resources
      render "new", layout: "editor"
    end
  end

  def update
    id = params[:id]
    return unless access_granted?(id)

    @article = Article.find(id)

    if params[:article][:draft]
      fetch_fresh_or_existing_draft_for_article
    else
      @article = Article.find(@article.parent_id) unless @article.parent_id.nil?
    end

    update_article_attributes

    if @article.draft
      @article.state = "draft"
    elsif @article.draft?
      @article.publish!
    end

    if @article.save
      Article.where(parent_id: @article.id).map(&:destroy) unless @article.draft
      flash[:success] = I18n.t("admin.content.update.success")
      redirect_to action: "index"
    else
      @article.keywords = Tag.collection_to_string @article.tags
      load_resources
      render "edit"
    end
  end

  def destroy
    destroy_a(Article)
  end

  def auto_complete_for_article_keywords
    @items = Tag.select(:display_name).order(:display_name).map(&:display_name)
    render json: @items
  end

  def autosave
    return false unless request.xhr?

    id = params[:article][:id] || params[:id]

    article_factory = Article::Factory.new(this_blog, current_user)
    @article = article_factory.get_or_build_from(id)

    fetch_fresh_or_existing_draft_for_article

    @article.attributes = params[:article].permit!

    @article.author = current_user
    @article.save_attachments!(params[:attachments])
    @article.state = "draft" unless @article.withdrawn?
    @article.text_filter ||= current_user.default_text_filter

    if @article.title.blank?
      lastid = Article.order("id desc").first.id
      @article.title = "Draft article #{lastid}"
    end

    if @article.save
      flash[:success] = I18n.t("admin.content.autosave.success")
      @must_update_calendar =
        (params[:article][:published_at] and
         params[:article][:published_at].to_time.to_i < Time.zone.now.to_time.to_i and
         @article.parent_id.nil?)
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def fetch_fresh_or_existing_draft_for_article
    return unless @article.published? && @article.id

    parent_id = @article.id
    @article =
      this_blog.articles.drafts.child_of(parent_id).first || this_blog.articles.build
    @article.allow_comments = this_blog.default_allow_comments
    @article.allow_pings = this_blog.default_allow_pings
    @article.parent_id = parent_id
  end

  attr_accessor :resources, :resource

  def load_resources
    @post_types = PostType.all
    @macros = TextFilterPlugin.macro_filters
  end

  def access_granted?(article_id)
    article = Article.find(article_id)
    if article.access_by? current_user
      true
    else
      flash[:error] = I18n.t("admin.content.access_granted.error")
      redirect_to action: "index"
      false
    end
  end

  def update_article_attributes
    @article.assign_attributes(update_params)
    @article.author = current_user
    @article.save_attachments!(params[:attachments])
    @article.text_filter_name ||= default_text_filter
  end

  def update_params
    params.
      require(:article).
      permit(:allow_comments,
             :allow_pings,
             :body,
             :body_and_extended,
             :draft,
             :extended,
             :password,
             :permalink,
             :published_at,
             :text_filter_name,
             :title,
             :keywords)
  end

  def default_text_filter
    current_user.text_filter || this_blog.text_filter
  end
end
