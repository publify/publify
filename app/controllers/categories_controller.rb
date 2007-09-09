class CategoriesController < GroupingController
  def index
    @categories = Category.find_all_with_article_counters(1000)
    respond_to do |format|
      format.html do
        unless template_exists?
          @grouping_class = Category
          @groupings = @categories
          render :template => 'articles/groupings'
        end
      end
    end
  end

  def show
    @page_title = "category #{params[:id]}"
    @category = Category.find_by_permalink(params[:id])
    
    render_articles(@category.published_articles)
  end
end
