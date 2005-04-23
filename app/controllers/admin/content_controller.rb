class Admin::ContentController < Admin::BaseController
  
  def index
    list
    render_action 'list'
  end

  def list
    @articles = Article.find(:all, :order => "articles.id DESC", :include => [ :trackbacks, :comments ])
  end

  def show
    @article = Article.find(@params['id'])
  end

  def new
    @article = Article.new(@params["article"])
    @article.author = @session[:user].login
    if @request.post? and @article.save
      flash['notice'] = 'Article was successfully created.'
      redirect_to :action => 'show', :id => @article.id
    end      
  end

  def edit
    @article = Article.find(@params['id'])
    @article.attributes = @params["article"]
    if @request.post? and @article.save
      flash['notice'] = 'Article was successfully updated.'
      redirect_to :action => 'show', :id => @article.id
    end      
  end

  def destroy
    @article = Article.find(@params['id'])
    if @request.post?
      @article.destroy
      redirect_to :action => 'list'
    end
  end
  
  def preview
    render_text RedCloth.new(request.raw_post).to_html
  end
  
end
