class CommentsController < FeedbackController
  before_action :get_article, only: [:create, :preview]

  def create
    @comment = @article.with_options(new_comment_defaults) do |art|
      art.add_comment(params[:comment].slice(:body, :author, :email, :url))
    end

    unless current_user.nil? || session[:user_id].nil?
      # maybe useless, but who knows ?
      @comment.user_id = current_user.id if current_user.id == session[:user_id]
    end

    set_cookies_for @comment

    partial = '/articles/comment_failed'
    if recaptcha_ok_for?(@comment)  && @comment.save
      partial = '/articles/comment'
    end
    if request.xhr?
      render partial: partial, object: @comment
    else
      redirect_to URI.parse(@article.permalink_url).path
    end
  end

  def preview
    session session: new unless session

    comment_params = params[:comment]
    if comment_params[:body].blank?
      render nothing: true
      return
    end

    set_headers
    @comment = Comment.new(comment_params)

    return render text: 'Comments are closed' if @article.comments_closed?

    render 'articles/comment_preview', locals: { comment: @comment }
  end

  protected

  def recaptcha_ok_for?(comment)
    use_recaptcha = Blog.default.settings['use_recaptcha']
    ((use_recaptcha && verify_recaptcha(model: comment)) || !use_recaptcha)
  end

  def new_comment_defaults
    { ip: request.remote_ip,
      author: 'Anonymous',
      published: true,
      user: @current_user,
      user_agent: request.env['HTTP_USER_AGENT'],
      referrer: request.env['HTTP_REFERER'],
      permalink: @article.permalink_url }.stringify_keys
  end

  def set_headers
    headers['Content-Type'] = 'text/html; charset=utf-8'
  end

  def set_cookies_for(comment)
    add_to_cookies(:author, comment.author)
    add_to_cookies(:url, comment.url)
    unless comment.email.blank?
      add_to_cookies(:gravatar_id, Digest::MD5.hexdigest(comment.email.strip))
    end
  end

  def get_article
    @article = Article.find(params[:article_id])
  end
end
