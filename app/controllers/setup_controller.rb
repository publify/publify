class SetupController < ApplicationController
  before_filter :check_config, :only => 'index'
  layout 'setup'
  
  def index
    if request.post?
      Blog.transaction do
        this_blog.blog_name = params[:setting][:blog_name]  
        this_blog.base_url = blog_base_url
        this_blog.save    
      end
      
      @user = User.new(:login => 'admin', :email => params[:setting][:email])

        @user.password = generate_password
        session[:tmppass] = @user.password
        @user.name = @user.login
        if @user.save
          self.current_user = @user
          session[:user_id] = @user.id

          # Crappy hack : by default, the auto generated post is user_id less and it makes Typo crash
          if User.count == 1
            art = Article.find(:first)
            art.user_id = @user.id
            art.save
          end
        end
      redirect_to :action => 'confirm'
    end
  end

  private
  def generate_password
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(7) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
  
  def check_config
    return unless this_blog.configured?
    redirect_to :controller => 'articles', :action => 'index'
  end
end