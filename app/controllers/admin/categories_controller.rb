class Admin::CategoriesController < Admin::BaseController
  
  def index
    list
    render_action 'list'
  end

  def list
    @categories = Category.find(:all, :order => 'name')
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new(params[:category])
    
    if request.post? and @category.save
      flash[:notice] = 'Category was successfully created.'
      redirect_to :action => 'list'
    end      
  end

  def edit
    @category = Category.find(params[:id])
    @category.attributes = params[:category]
    if request.post? and @category.save
      flash[:notice] = 'Category was successfully updated.'
      redirect_to :action => 'list'
    end      
  end

  def destroy
    @category = Category.find(params[:id])
    if request.post?
      @category.destroy
      redirect_to :action => 'list'
    end
  end
  
end
