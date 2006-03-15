class Admin::CommentsController < Admin::BaseController

  before_filter :get_article
  cache_sweeper :blog_sweeper

  def index
    list
    render_action 'list'
  end

  def list
    @comments = @article.comments.find(:all, :order => "id DESC")
  end

  def show
    @comment = @article.comments.find(params[:id])
  end

  def new
    @comment = @article.comments.build(params[:comment])

    if request.post? and @comment.save
      flash[:notice] = 'Comment was successfully created.'
      redirect_to :action => 'show', :id => @comment.id
    end
  end

  def edit
    @comment = @article.comments.find(params[:id])
    @comment.attributes = params[:comment]

    if request.post? and @comment.save
      flash[:notice] = 'Comment was successfully updated.'
      redirect_to :action => 'show', :id => @comment.id
    end
  end

  def destroy
    @comment = @article.comments.find(params[:id])
    if request.post?
      @comment.destroy
      redirect_to :action => 'list'
    end
  end

  private

    def get_article
      @article = Article.find(params[:article_id])

      if @article.nil?
        redirect_to '/admin'
      end
    end

end
