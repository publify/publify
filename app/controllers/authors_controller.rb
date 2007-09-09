class AuthorsController < GroupingController

  def index
    @authors = User.find_all_with_article_counters(1000)
    respond_to do |format|
      format.html do
        unless template_exists?
          @grouping_class = User
          @groupings = @authors
          render :template => 'articles/groupings'
        end
      end
    end
  end

  def show
    @page_title = "user #{params[:id]}"
    @author = User.find_by_permalink(params[:id])
    
    render_articles(@author.published_articles)
  end
end
