class ArticlesController < ApplicationController
  cache_sweeper :blog_sweeper, :only => "comment"
  
  before_filter :verify_user_exists
  before_filter :verify_config
  
  def index
    @pages = Paginator.new self, Article.count, 10, @params['page']
    @articles = Article.find_all('published !=0', 'created_at DESC', @pages.current.to_sql)
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
    
  def permalink
    @article    = Article.find_by_permalink(@params["year"], @params["month"], @params["day"], @params["title"])
    @comment    = Comment.new
    @page_title = @article.title

    fill_from_cookies(@comment)    
    render_action "read"
  end
  
  def find_by_date
    @pages = Paginator.new self, Article.count_by_date(@params["year"], @params["month"], @params["day"]), 10, @params['page']
    @articles = Article.find_all_by_date(@params["year"], @params["month"], @params["day"], @pages.current.to_sql)
    render_action "index"              
  end  
  
  def error(message = "Record not found")
    @message = message
    render_action "error"
  end
  
  def category
    if category = Category.find_by_name(@params['id'])
      @pages = Paginator.new self, category.articles.size, 10, @params['page']

      start = @pages.current.offset
      stop  = @pages.current.next.offset rescue category.articles.size
      @articles = category.articles.slice(start..stop)

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
  
    def verify_user_exists
      redirect_to :controller => "accounts", :action => "signup" if User.find_all.length == 0
    end

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
