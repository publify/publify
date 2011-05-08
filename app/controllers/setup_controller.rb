class SetupController < ApplicationController
  before_filter :check_config, :only => 'index'
  layout 'accounts'

  def index    
    if request.post?
      # This is not a model and I can't handle errors in the models so I just do
      # crappy old school params checking here
      errmsg = ""
      if params[:setting] and params[:setting][:blog_name].to_s.empty?
        errmsg << _("Blog name is mandatory")
      end
      if params[:setting] and params[:setting][:email].to_s.empty?
        errmsg << _("Email is mandatory")
        error = 1
      end

      unless errmsg.empty?
        flash[:error] = errmsg
        redirect_to :action => 'index'
        return
      end
      
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

        # FIXME: Crappy hack : by default, the auto generated post is user_id less and it makes Typo crash
        if User.count == 1
          art = Article.find(:first)
          art.user_id = @user.id
          art.save
        end
        redirect_to :action => 'confirm'
      end
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
