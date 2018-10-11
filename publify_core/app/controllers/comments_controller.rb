# frozen_string_literal: true

class CommentsController < BaseController
  before_action :set_article, only: [:create, :preview]

  def create
    options = new_comment_defaults.merge comment_params.to_h
    @comment = @article.add_comment(options)

    unless current_user.nil? || session[:user_id].nil?
      # maybe useless, but who knows ?
      @comment.user_id = current_user.id if current_user.id == session[:user_id]
    end

    remember_author_info_for @comment

    partial = '/articles/comment_failed'
    partial = '/articles/comment' if recaptcha_ok_for?(@comment) && @comment.save
    respond_to do |format|
      format.js { render partial }
      format.html { redirect_to URI.parse(@article.permalink_url).path }
    end
  end

  def preview
    return render plain: 'Comments are closed' if @article.comments_closed?

    if comment_params[:body].blank?
      head :ok
      return
    end

    @comment = @article.comments.build(comment_params)
  end

  protected

  def recaptcha_ok_for?(comment)
    use_recaptcha = comment.blog.use_recaptcha
    ((use_recaptcha && verify_recaptcha(model: comment)) || !use_recaptcha)
  end

  def new_comment_defaults
    { ip: request.remote_ip,
      author: 'Anonymous',
      user: @current_user,
      user_agent: request.env['HTTP_USER_AGENT'],
      referrer: request.env['HTTP_REFERER'],
      permalink: @article.permalink_url }.stringify_keys
  end

  def remember_author_info_for(comment)
    add_to_cookies(:author, comment.author)
    add_to_cookies(:url, comment.url)
    add_to_cookies(:gravatar_id, Digest::MD5.hexdigest(comment.email.strip)) if comment.email.present?
  end

  def set_article
    @article = Article.find(params[:article_id])
  end

  def comment_params
    @comment_params ||= params.require(:comment).permit(:body, :author, :email, :url)
  end
end
