class ArticlesController < ApplicationController

  def index
    @articles = Article.find_all('published !=0', 'created_at DESC', '10')
  end
  
  def search
    @articles = Article.search(@params["q"])
  end
  
  def comment
    if @request.post?
      @comment = Comment.new
      
    end
    
    return 
        
  end
  
  def read    
    @article = Article.find(@params["id"])    
    @comment = Comment.new(@params["comment"])
    @comment.article = @article

    if @request.post?
      @comment.save
      @comment.body = ""
      
      cookies['author']  = { :value => @comment.author, :expires => 2.weeks.from_now } 
      cookies['email']   = { :value => @comment.email, :expires => 2.weeks.from_now } 
      cookies['url']     = { :value => @comment.url, :expires => 2.weeks.from_now } 
    end

    fill_from_cookies(@comment)    
  end
  
  
  private
    
    def fill_from_cookies(comment)      
      comment.author  ||= cookies['author']
      comment.url     ||= cookies['url']
      comment.email   ||= cookies['email']
    end

end
