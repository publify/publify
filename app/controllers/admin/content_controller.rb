class Admin::ContentController < Admin::BaseController

  cache_sweeper :blog_sweeper

  def index
    list
    render_action 'list'
  end

  def list
    @articles_pages, @articles = paginate :article, :per_page => 15, :order_by => "created_at DESC", :parameter => 'id'
    @categories = Category.find(:all)
    @article = Article.new(params[:article])
    @article.text_filter = config[:text_filter]
  end

  def show
    @article = Article.find(params[:id])
    @categories = Category.find(:all, :order => 'name')
  end

  def new
    @article = Article.new(params[:article])
    @article.author = session[:user].login
    @article.allow_comments ||= config[:default_allow_comments]
    @article.allow_pings ||= config[:default_allow_pings]
    @article.text_filter ||= config[:text_filter]
    @article.user = session[:user]
    
    @categories = Category.find_all
    if request.post?
      @article.categories.clear
      @article.categories << Category.find(params[:categories]) if params[:categories]
      if @article.save 
        flash[:notice] = 'Article was successfully created.'
        redirect_to :action => 'show', :id => @article.id
      end
    end
  end

  def edit
    @article = Article.find(params[:id])
    @article.attributes = params[:article]
    @categories = Category.find_all
    @selected = @article.categories.collect { |cat| cat.id.to_i }
    if request.post? 
      @article.categories.clear
      @article.categories << Category.find(params[:categories]) if params[:categories]
      if @article.save 
        flash[:notice] = 'Article was successfully updated.'
        redirect_to :action => 'show', :id => @article.id
      end
    end      
  end

  def destroy
    @article = Article.find(params[:id])
    if request.post?
      @article.destroy
      redirect_to :action => 'list'
    end
  end
  
  def category_add
    @article = Article.find(params[:id])
    @category = Category.find(params[:category_id])
    @article.categories << @category
    @article.save
    redirect_to :action => 'show', :id => @article.id
  end

  def category_remove
    @article = Article.find(params[:id])
    @category = Category.find(params[:category_id])
    @article.categories.delete(@category)
    @article.save    
    redirect_to :action => 'show', :id => @article.id
  end
  
  def preview
    @headers["Content-Type"] = "text/html; charset=utf-8"
    @article = params[:article]
    render :layout => false
  end
  
end
