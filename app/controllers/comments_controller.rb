class CommentsController < ApplicationController
  helper :theme

  session :new_session => false

  before_filter :get_article, :only => [:create, :update]

  def index
    article = nil
    if params[:article_id]
      article = this_blog.articles.find_by_params_hash(params)
      @comments = article.published_comments
    else
      limits = this_blog.limit_rss_display.to_i.zero? \
        ? { } \
        : {:limit => this_blog.limit_rss_display }
      @comments = this_blog.comments.find_all_by_published(true, limits.merge(:order => 'created_at DESC'))
    end

    respond_to do |format|
      format.html do
        if article
          redirect_to "#{article_path(article)}\#comments"
        else
          render :text => 'this space left blank'
        end
      end
      @feed_title = "#{this_blog.blog_name} : Comments"
      format.atom { render :partial => 'articles/atom_feed', :object => @comments }
      format.rss { render :partial => 'articles/rss20_feed', :object => @comments }
    end
  end

  def create
    if ! (this_blog.sp_allow_non_ajax_comments || request.xhr?)
      render :nothing => true, :status => 401
      return
    end

    @comment =
      @article.comments.build(params[:comment]\
                                .merge( :ip => request.remote_ip,
                                        :published => true,
                                        :user => session[:user],
                                        :user_agent => request.env['HTTP_USER_AGENT'],
                                        :referrer => request.env['HTTP_REFERER'],
                                        :permalink => article_path(@article)))
    @comment.author ||= 'Anonymous'
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
    if params[:comment].blank? or params[:comment][:body].blank?
      render :nothing => true
      return
    end

    set_headers
    @comment = this_blog.comments.build(params[:comment])

    render :template => 'articles/comment_preview'
  end

  protected

  def get_article
    @article = this_blog.published_articles.find_by_params_hash(params)

    if @article
      return true
    end

    render :text => "No such article", :status => 404
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
