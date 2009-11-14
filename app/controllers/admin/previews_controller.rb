class Admin::PreviewsController < Admin::BaseController
  before_filter :setup_themer
  
  def index
    @article = Article.find(params[:id])
    
    render :template => '/articles/read'
  end
  
end