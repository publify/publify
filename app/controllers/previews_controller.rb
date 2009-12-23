class PreviewsController < ContentController
  before_filter :login_required
  layout :theme_layout

  def index
    @article = Article.find(params[:id])
    while @article.has_child?
      @article = Article.child_of(@article.id).first
    end

    render :template => '/articles/read'
  end
end
