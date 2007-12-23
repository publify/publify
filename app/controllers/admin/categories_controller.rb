class Admin::CategoriesController < Admin::BaseController

  def index
    list
    render :action => 'list'
  end

  def list
    @categories = Category.find(:all, :order => :position)
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new(params[:category])

    if request.post? and @category.save
      flash[:notice] = _('Category was successfully created.')
    else
      flash[:error] = _('Category could not be created.')
    end

    redirect_to :action => 'list'
  end

  def edit
    @category = Category.find(params[:id])
    @category.attributes = params[:category]
    if request.post? and @category.save
      flash[:notice] = _('Category was successfully updated.')
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

  def order
    Category.reorder(params[:category_list])
    render :nothing => true
  end

  def asort
    Category.reorder_alpha
    category_container
  end

  def category_container
    @categories = Category.find(:all, :order => :position)
    render :partial => "categories"
  end

  def reorder
    @categories = Category.find(:all, :order => :position)
    render :layout => false
  end
end
