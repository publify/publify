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
    @message = message
    render_action "error"
  end
  
  def category
    if category = Category.find_by_name(@params['id'])    
      @articles = category.articles        
      render_action "index"
    else
      error("Can't find posts in category #{params['id']}")
    end
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

  # Receive trackbacks linked to articles
  def trackback
    @result = true

    # url is required
    unless @params.has_key?('url') and @params.has_key?('id')
      @result = false
      @error_message = "A url is required."
      return
    end

    begin
      article = Article.find(@params['id'])
      tb = article.build_to_trackbacks
      tb.url       = @params['url']
      tb.title     = @params['title'] || @params['url']
      tb.excerpt   = @params['excerpt']
      tb.blog_name = @params['blog_name']
      unless article.save
        @result = false
        @error_message = "Trackback not saved.  Database problem most likely."
      end
    rescue ActiveRecord::RecordNotFound, ActiveRecord::StatementInvalid
      @result = false
      @error_message = "Article id #{@params['id']} not found."
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
