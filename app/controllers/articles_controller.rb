class ArticlesController < ApplicationController
  
  cache_sweeper :blog_sweeper, :only => "comment"
  
  def index
    @articles = Article.find_all('published !=0', 'created_at DESC', '10')
  end
  
  def search
    @articles = Article.search(@params["q"])
  end
  
  def read    
    @article = Article.find(@params["id"])    
    @comment = Comment.new

    fill_from_cookies(@comment)    
  end
  
  def error(message = "Record not found")
    @message ||= message
    render_action "error"
  end
  
  
  def comment 
    @article = Article.find(@params["id"])    
    @comment = Comment.new(@params["comment"])
    @comment.article = @article
    if @request.post? and @comment.save      
      @comment.body = ""
      
      cookies['author']  = { :value => @comment.author, :expires => 2.weeks.from_now } 
      cookies['email']   = { :value => @comment.email, :expires => 2.weeks.from_now } 
      cookies['url']     = { :value => @comment.url, :expires => 2.weeks.from_now } 
      
      redirect_to :action=> "read", :id => @article.id 
    else
    
      render_action "read"
    end
  end  
  
  private
    
    def fill_from_cookies(comment)      
      comment.author  ||= cookies['author']
      comment.url     ||= cookies['url']
      comment.email   ||= cookies['email']
    end
    
    def rescue_action_in_public(exception)
      error(exception.message)
    end
end
