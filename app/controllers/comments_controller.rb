class CommentsController < FeedbackController
  before_filter :get_article, only: [:create, :preview]

  layout 'default.html.erb'

  def create
    @comment = @article.with_options(new_comment_defaults) do |art|
      art.add_comment(params[:comment].slice(:body, :author, :email, :url))
    end

    unless current_user.nil? or session[:user_id].nil?
      # maybe useless, but who knows ?
      if current_user.id == session[:user_id]
        @comment.user_id = current_user.id
      end
    end

    session[:author] = @comment.author  if @comment.author.present?
    session[:email] = @comment.email if @comment.email.present?

    if recaptcha_ok_for?(@comment)  && @comment.save
      redirect_to @article.permalink_url + "#comment-#{@comment.id}"
    else
      @page_title = @article.title_meta_tag.present? ? @article.title_meta_tag : @article.title
      @description = @article.description_meta_tag
      @keywords = @article.tags.map { |g| g.name }.join(', ')

      render "articles/#{@article.post_type}"
    end

  end

  def preview
    if !session
      session session: new
    end

    comment_params = params[:comment]
    if (params_comment[:body].blank? rescue true)
      render nothing: true
      return
    end

    set_headers
    @comment = Comment.new(params_comment)

    unless @article.comments_closed?
      render 'articles/comment_preview', locals: { comment: @comment }
    else
      render text: 'Comment are closed'
    end
  end

  protected

  def recaptcha_ok_for? comment
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

  def get_article
    @article = Article.find(params[:article_id])
  end
end
