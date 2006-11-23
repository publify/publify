class LiveController < ContentController
  session :off

  def search
    @search = params[:q]
    @articles = Article.search(@search)
    headers["Content-Type"] = "text/html; charset=utf-8"
  end

end
