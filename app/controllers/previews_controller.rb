class PreviewsController < ContentController
  before_filter :login_required
  layout :theme_layout

  def self.controller_path
    'articles'
  end

  def index
    @article = Article.last_draft(params[:id])
    render :action => 'read'
  end
end
