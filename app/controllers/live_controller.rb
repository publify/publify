class LiveController < ApplicationController

  def search
    @search = @request.raw_post
    @articles = Article.search(@search)
    @headers["Content-Type"] = "text/html; charset=utf-8"
  end
  
end