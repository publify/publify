class LiveController < ApplicationController

  def search
    @articles = Article.search(@request.raw_post) unless @request.raw_post.blank?
  end
  
end