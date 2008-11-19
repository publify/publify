class Admin::CategoriesController < Admin::BaseController

  cache_sweeper :blog_sweeper

  def index
    @categories = Category.find(:all, :order => :position, :conditions => { :parent_id => nil })
  end

  def new; new_or_edit ; end
  def edit; new_or_edit;  end

  def destroy
    @category = Category.find(params[:id])
    if request.post?
      @category.destroy
      redirect_to :action => 'index'
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
  
  private
  
  def new_or_edit
    @category = case params[:id]
    when nil
      Category.new
    else
      Category.find(params[:id])
    end
    @category.attributes = params[:category]
    if request.post?
      save_category
      return
    end    
    render :action => 'new'
  end
  
  def save_category
    if @category.save!
      flash[:notice] = _('Category was successfully saved.') 
    else
      flash[:error] = _('Category could not be saved.')
    end
      redirect_to :action => 'index'
  end
  
end
