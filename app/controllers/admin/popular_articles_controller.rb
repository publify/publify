class Admin::PopularArticlesController < Admin::BaseController

  def new
    @popular_article = PopularArticle.last_or_initialize
  end

  def create
    @popular_article = PopularArticle.last_or_initialize
    @popular_article.attributes = params[:popular_article].permit!

    if @popular_article.save
      redirect_to admin_dashboard_path
    else
      render :new
    end
  end
end

