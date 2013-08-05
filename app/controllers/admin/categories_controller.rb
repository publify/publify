class Admin::CategoriesController < Admin::BaseController
  cache_sweeper :blog_sweeper

  def index; redirect_to action: 'new' ; end
  def edit; new_or_edit;  end

  def new
    respond_to do |format|
      format.html { new_or_edit }
      format.js {
        @category = Category.new
      }
    end
  end

  def destroy
    destroy_a(Category)
  end

  private

  def new_or_edit
    @categories = Category.find(:all)
    @category = case params[:id]
                when nil
                  Category.new
                else
                  Category.find(params[:id])
                end
    @category.attributes = params[:category]
    if request.post?
      respond_to do |format|
        format.html { save_a(@category, 'category') }
        format.js do
          @category.save
          @article = Article.new
          @article.categories << @category
          return render(:partial => 'admin/content/categories')
        end
      end
      return
    else
      render 'new'
    end
  end
end
