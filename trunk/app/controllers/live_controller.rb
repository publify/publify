class LiveController < ApplicationController

  def search
    @search = @request.raw_post
    @articles = Article.search(@search)
  end
  
end