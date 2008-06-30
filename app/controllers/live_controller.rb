class LiveController < ContentController
  skip_before_filter :verify_authenticity_token
  session :off

  def search
    @search = params[:q]
    @articles = Article.search(@search)
    headers["Content-Type"] = "text/html; charset=utf-8"
  end

end
