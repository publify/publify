class Admin::CommentsController < Admin::BaseController

  before_filter :get_article

  def index
    list
    render :action => 'list'
  end

  def list
    @comments = @article.comments.find(:all, :order => "id ASC")
  end

  def show
    @comment = @article.comments.find(params[:id])
  end

  def new
    @comment = @article.comments.build(params[:comment])

    if request.post? and @comment.save
      # We should probably wave a spam filter over this, but for now, just mark it as published.
      @comment.mark_as_ham!
      flash[:notice] = 'Comment was successfully created.'
      redirect_to :controller => '/admin/comments', :article_id => @article.id, :action => 'list'
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
