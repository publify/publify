# frozen_string_literal: true

class ArticlesController < ContentController
  before_action :login_required, only: [:preview, :preview_page]
  before_action :auto_discovery_feed, only: [:show, :index]
  before_action :verify_config

  layout :theme_layout, except: [:trackback]

  helper :'admin/base'

  def index
    wanted_types = this_blog.statuses_in_timeline ? ['Article', 'Note'] : ['Article']

    limit = this_blog.per_page(params[:format])
    articles_base = if params[:year].blank?
                      this_blog.contents.published
                    else
                      this_blog.contents.published_at(params.values_at(:year, :month, :day))
                    end
    @articles = articles_base.includes(:user, :resources, :tags, :text_filter).
      where(type: wanted_types).page(params[:page]).per(limit)

    respond_to do |format|
      format.html do
        set_index_title_and_description(this_blog, params)
        @keywords = this_blog.meta_keywords

        render_paginated_index
      end
      format.atom do
        render_articles_feed('atom')
      end
      format.rss do
        auto_discovery_feed(only_path: false)
        render_articles_feed('rss')
      end
    end
  end

  def search
    @articles = this_blog.articles_matching(params[:q], page: params[:page], per_page: this_blog.per_page(params[:format]))
    return error! if @articles.empty?

    @page_title = this_blog.search_title_template.to_title(@articles, this_blog, params)
    @description = this_blog.search_desc_template.to_title(@articles, this_blog, params)
    respond_to do |format|
      format.html { render 'search' }
      format.rss { render_articles_feed 'rss' }
      format.atom { render_articles_feed 'atom' }
    end
  end

  def live_search
    @search = params[:q]
    @articles = Article.search(@search)
    render :live_search, layout: false
  end

  def preview
    @article = Article.last_draft(params[:id])
    @page_title = this_blog.article_title_template.to_title(@article, this_blog, params)
    render 'read'
  end

  def check_password
    return unless request.xhr?

    @article = Article.find(params[:article][:id])
    if @article.password == params[:article][:password]
      render partial: 'articles/full_article_content', locals: { article: @article }
    else
      render partial: 'articles/password_form', locals: { article: @article }
    end
  end

  def redirect
    from = extract_feed_format(params[:from])
    factory = Article::Factory.new(this_blog, current_user)

    @article = factory.match_permalink_format(from, this_blog.permalink_format)
    return show_article if @article

    # Redirect old version with /:year/:month/:day/:title to new format,
    # because it's changed
    ['%year%/%month%/%day%/%title%', 'articles/%year%/%month%/%day%/%title%'].each do |part|
      @article = factory.match_permalink_format(from, part)
      return redirect_to URI.parse(@article.permalink_url).path, status: :moved_permanently if @article
    end

    r = Redirect.find_by!(from_path: from)
    # TODO: If linked to article, directly redirect to the article.
    # Let redirection made outside of the blog on purpose (deal with it, Brakeman!)
    redirect_to r.full_to_path, status: :moved_permanently if r
  end

  def archives
    limit = this_blog.limit_archives_display
    @articles = this_blog.published_articles.includes(:tags).page(params[:page]).per(limit)
    @page_title = this_blog.archives_title_template.to_title(@articles, this_blog, params)
    @keywords = this_blog.meta_keywords
    @description = this_blog.archives_desc_template.to_title(@articles, this_blog, params)
  end

  def tag
    redirect_to tags_path, status: :moved_permanently
  end

  def preview_page
    @page = Page.find(params[:id])
    render 'view_page'
  end

  def view_page
    @page = Page.published.find_by!(name: Array(params[:name]).join('/'))
    @page_title = @page.title
    @description = this_blog.meta_description
    @keywords = this_blog.meta_keywords
  end

  # TODO: Move to TextfilterController?
  def markup_help
    render html: TextFilter.find(params[:id]).commenthelp
  end

  private

  def set_index_title_and_description(blog, parameters)
    @page_title = blog.home_title_template
    @description = blog.home_desc_template
    if parameters[:year]
      @page_title = blog.archives_title_template
      @description = blog.archives_desc_template
    elsif parameters[:page]
      @page_title = blog.paginated_title_template
      @description = blog.paginated_desc_template
    end
    @page_title = @page_title.to_title(@articles, blog, parameters)
    @description = @description.to_title(@articles, blog, parameters)
  end

  def verify_config
    if !this_blog.configured?
      redirect_to controller: 'setup', action: 'index'
    elsif User.count == 0
      redirect_to new_user_registration_path
    else
      true
    end
  end

  # See an article We need define @article before
  def show_article
    auto_discovery_feed
    respond_to do |format|
      format.html do
        @comment = Comment.new
        @page_title = this_blog.article_title_template.to_title(@article, this_blog, params)
        @description = this_blog.article_desc_template.to_title(@article, this_blog, params)

        @keywords = @article.tags.map(&:name).join(', ')
        render "articles/#{@article.post_type}"
      end
      format.atom { render_feedback_feed('atom') }
      format.rss { render_feedback_feed('rss') }
      format.xml { render_feedback_feed('atom') }
    end
  rescue ActiveRecord::RecordNotFound
    error!
  end

  def render_articles_feed(format)
    render_cached_xml("index_#{format}_feed", @articles)
  end

  def render_feedback_feed(format)
    render_cached_xml("feedback_#{format}_feed", @article)
  end

  def render_paginated_index
    return error! if @articles.empty?

    auto_discovery_feed(only_path: false)
    render 'index'
  end

  def extract_feed_format(from)
    if from =~ /^.*\.rss$/
      request.format = 'rss'
      from = from.gsub(/\.rss/, '')
    elsif from =~ /^.*\.atom$/
      request.format = 'atom'
      from = from.gsub(/\.atom$/, '')
    end
    from
  end

  def error!
    @message = I18n.t('errors.no_posts_found')
    render 'articles/error', status: :ok
  end
end
