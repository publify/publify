class LiveController < ApplicationController

  def search
    @articles = Article.search(@params["q"])
  end
  
end