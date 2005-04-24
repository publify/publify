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
    @categories = Category.find(:all)
  end

  def new
    @article = Article.new(@params["article"])
    @article.author = @session[:user].login
    @article.allow_comments = config["default_allow_comments"]
    @article.allow_pings = config["default_allow_pings"]
    @article.text_filter = config["text_filter"]
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
  
  def category_add
    @article = Article.find(@params['id'])
    @category = Category.find(@params['category_id'])
    @article.categories << @category
    
    redirect_to :action => 'show', :id => @article.id
  end

  def category_remove
    @article = Article.find(@params['id'])
    @category = Category.find(@params['category_id'])
    @article.categories.delete(@category)
    
    redirect_to :action => 'show', :id => @article.id
  end
  
  def preview
    render_text HtmlEngine.transform(request.raw_post, config[:text_filter])
  end
  
end
