class CommentsController < FeedbackController
  before_filter :check_request_type, :only => [:create]

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

  def get_feedback
    @comments = \
      if params[:article_id]
        this_blog.requested_article(params).published_comments
      else
        this_blog.published_comments.with_options(this_blog.rss_limit_params) do |c|
          c.find(:all, :order => 'created_at DESC')
        end
      end
  end

  def new_comment_defaults
    return { :ip  => request.remote_ip,
      :author     => 'Anonymous',
      :published  => true,
      :user       => current_user,
      :user_agent => request.env['HTTP_USER_AGENT'],
      :referrer   => request.env['HTTP_REFERER'],
      :permalink  => article_path(@article) }
  end

  def set_headers
    headers["Content-Type"] = "text/html; charset=utf-8"
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
