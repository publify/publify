class CommentsController < FeedbackController
  before_filter :get_article, :only => [:create, :preview]

  def create
    @comment = @article.with_options(new_comment_defaults) do |art|
      art.add_comment(params[:comment].symbolize_keys)
    end

    unless current_user.nil? or session[:user_id].nil?
      # maybe useless, but who knows ?
      if current_user.id == session[:user_id]
        @comment.user_id = current_user.id
      end
    end

    set_cookies_for @comment

    partial = '/articles/comment_failed'
    if recaptcha_ok_for?(@comment)  && @comment.save
      partial = '/articles/comment'
    end
    if request.xhr?
      render :partial => partial, :object => @comment 
    else
      redirect_to @article.permalink_url
    end
  end

  def preview
    if !session
      session :session => new
    end

    comment_params = params[:comment]
    if (params_comment[:body].blank? rescue true)
      render :nothing => true
      return
    end

    set_headers
    @comment = Comment.new(params_comment)

    unless @article.comments_closed?
      render 'articles/comment_preview', :locals => { :comment => @comment }
    else
      render :text => 'Comment are closed'
    end
  end

  protected

  def recaptcha_ok_for? comment
    use_recaptcha = Blog.default.settings["use_recaptcha"]
    ((use_recaptcha && verify_recaptcha(:model => comment)) || !use_recaptcha)
  end

  def get_feedback
    @comments = \
      if params[:article_id]
        Article.find(params[:article_id]).published_comments
      else
        Comment.find_published(:all, this_blog.rss_limit_params.merge(:order => 'created_at DESC'))
      end
  end

  def new_comment_defaults
    { :ip  => request.remote_ip,
      :author     => 'Anonymous',
      :published  => true,
      :user       => @current_user,
      :user_agent => request.env['HTTP_USER_AGENT'],
      :referrer   => request.env['HTTP_REFERER'],
      :permalink  => @article.permalink_url }
  end

  def set_headers
    headers["Content-Type"] = "text/html; charset=utf-8"
  end

  def set_cookies_for comment
    add_to_cookies(:author, comment.author)
    add_to_cookies(:url, comment.url)
    if ! comment.email.blank?
      add_to_cookies(:gravatar_id, Digest::MD5.hexdigest(comment.email.strip))
    end
  end

  def get_article
    @article = Article.find(params[:article_id])
  end
end
