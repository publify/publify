class Admin::TrackbacksController < Admin::BaseController

  before_filter :get_article

  def index
    list
    render :action => 'list'
  end

  def list
    @trackbacks = @article.trackbacks.find(:all, :order => "id DESC")
  end

  def show
    @trackback = @article.trackbacks.find(params[:id])
  end

  def new
    @trackback = @article.trackbacks.build(params[:trackback])

    if request.post? and @trackback.save
      flash[:notice] = 'Trackback was successfully created.'
      redirect_to :action => 'show', :id => @trackback.id
    end
  end

  def edit
    @trackback = @article.trackbacks.find(params[:id])
    @trackback.attributes = params[:trackback]
    if request.post? and @trackback.save
      flash[:notice] = 'Trackback was successfully updated.'
      redirect_to :action => 'show', :id => @trackback.id
    end
  end

  def destroy
    @trackback = @article.trackbacks.find(params[:id])
    if request.post?
      @trackback.destroy
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
