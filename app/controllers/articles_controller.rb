class ArticlesController < ApplicationController

  def index
    @articles = Article.find_all('published !=0 ', 'created_at DESC', '10')
  end
end
