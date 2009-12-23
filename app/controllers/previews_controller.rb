class PreviewsController < ContentController
  before_filter :login_required
  layout :theme_layout

  def index
    @article = Article.last_draft(params[:id])
    render :template => '/articles/read'
  end
end
