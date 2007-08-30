class CommentsController < ApplicationController
  helper :theme

  session :new_session => false

  before_filter :get_article, :only => [:create, :update]
  before_filter :check_request_type, :only => [:create]

  cache_sweeper :blog_sweeper

  def index
    article = nil
    if params[:article_id]
      article = this_blog.requested_article(params)
      @comments = article.published_comments
    else
      this_blog.with_options(this_blog.rss_limit_params) do |b|
        @comments = b.published_comments(:order => 'created_at DESC')
      end
    end

    @page_title = "Comments"
    respond_to do |format|
      format.html do
        if article
          redirect_to "#{article_path(article)}\#comments"
        else
          render :text => 'this space left blank'
        end
      end
      format.atom { render :partial => 'articles/atom_feed', :object => @comments }
      format.rss { render :partial => 'articles/rss20_feed', :object => @comments }
    end
  end

  def create
    @comment = @article.with_options(new_comment_defaults) do |art|
      art.add_comment(params[:comment].symbolize_keys)
    end

    set_comment_cookies

    if @comment.save
      if request.xhr?
        render :partial => '/articles/comment', :object => @comment
      else
        redirect_to article_path(@article)
      end
    end
  end

  def preview
    if (params[:comment][:body].blank? rescue true)
      render :nothing => true
      return
    end

    set_headers
    @comment = this_blog.comments.build(params[:comment])

    render :template => 'articles/comment_preview'
  end

  protected

  def new_comment_defaults
    return { :ip  => request.remote_ip,
      :author     => 'Anonymous',
      :published  => true,
      :user       => session[:user],
      :user_agent => request.env['HTTP_USER_AGENT'],
      :referrer   => request.env['HTTP_REFERER'],
      :permalink  => article_path(@article) }
  end

  def set_headers
    headers["Content-Type"] = "text/html; charset=utf-8"
  end

  def get_article
    @article = this_blog.requested_article(params)
  rescue ActiveRecord::RecordNotFound
    render :text => "No such article", :status => 404
    return false
  end

  def check_request_type
    return true if this_blog.sp_allow_non_ajax_comments || request.xhr?
    render :nothing => true, :status => :bad_request
    return false
  end

  def set_comment_cookies
    add_to_cookies(:author, @comment.author)
    if ! @comment.email.blank?
      add_to_cookies(:gravatar_id, Digest::MD5.hexdigest(@comment.email.strip))
    end
    add_to_cookies(:url, @comment.url)
  end
end
