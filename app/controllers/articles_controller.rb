class ArticlesController < ApplicationController
  cache_sweeper :blog_sweeper, :only => "comment"
  
  before_filter :verify_config
  
  def index
    @articles = Article.find_all('published !=0', 'created_at DESC', '10')
  end
  
  def search
    @articles = Article.search(@params["q"])
  end
  
  def read    
    @article      = Article.find(@params["id"])    
    @comment      = Comment.new
    @page_title   = @article.title

    fill_from_cookies(@comment)    
  end
  
  def find_by_date
    @articles = Article.find_all_by_date(@params["year"], @params["month"], @params["day"])
    render_action "index"              
  end
  
  def permalink
    @article = Article.find_by_permalink(@params["year"], @params["month"], @params["day"], @params["title"])
    @comment = Comment.new

    fill_from_cookies(@comment)    
    render_action "read"      

    unless @params["year"].blank? or @params["month"].blank? or @params["day"].blank? or @params["title"].blank?
    else
      @articles = Article.find_all_by_date(@params["year"], @params["month"], @params["day"])
      render_action "index"            
    end
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
      cookies['url']     = { :value => @comment.url, :expires => 2.weeks.from_now } 
      
      render_partial("comment", @comment)      
    else
    
      render_text "Please supply name and a message..."
    end
  end  

  # Receive trackbacks linked to articles
  def trackback
    @result = true
    
    if @params['__mode'] == "rss"
      # Part of the trackback spec... will implement later
    else
      # url is required
      unless @params.has_key?('url') and @params.has_key?('id')
        @result = false
        @error_message = "A url is required."
      else
        begin
          article = Article.find(@params['id'])
          tb = article.build_to_trackbacks
          tb.url       = @params['url']
          tb.title     = @params['title'] || @params['url']
          tb.excerpt   = @params['excerpt']
          tb.blog_name = @params['blog_name']
          tb.ip        = request.remote_ip
          unless article.save
            @result = false
            @error_message = "Trackback not saved.  Database problem most likely."
          end
        rescue ActiveRecord::RecordNotFound, ActiveRecord::StatementInvalid
          @result = false
          @error_message = "Article id #{@params['id']} not found."
        end
      end
    end
    render_without_layout
  end
  
  private

    def verify_config      
      redirect_to :controller => "settings", :action => "install" if !config.is_ok?
    end
    
    def fill_from_cookies(comment)      
      comment.author  ||= cookies['author']
      comment.url     ||= cookies['url']
    end
    
    def rescue_action_in_public(exception)
      error(exception.message)
    end

end
