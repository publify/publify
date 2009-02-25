class AccountsController < ApplicationController

  before_filter :verify_users, :only => [:login]

  def login 
    if session[:user_id] && session[:user_id] == self.current_user.id
      redirect_back_or_default :controller => "admin/dashboard", :action => "index"
      return
    end
      
    @page_title = "#{this_blog.blog_name} - #{_('login')}"
    case request.method
      when :post
      self.current_user = User.authenticate(params[:user_login], params[:user_password])
            
      if logged_in?
        session[:user_id] = self.current_user.id

        if params[:remember_me] == "1"
          self.current_user.remember_me unless self.current_user.remember_token?
          cookies[:auth_token] = {
            :value => self.current_user.remember_token,
            :expires => self.current_user.remember_token_expires_at,
            :http_only => true # Help prevent auth_token theft.
          }
        end
        add_to_cookies(:typo_user_profile, self.current_user.profile.label, '/')

        flash[:notice]  = _("Login successful")
        redirect_back_or_default :controller => "admin/dashboard", :action => "index"
      else
        flash.now[:error]  = _("Login unsuccessful")
        @login = params[:user_login]
      end
    end
  end
  
  def signup
    @page_title = "#{this_blog.blog_name} - #{_('signup')}"
    unless User.count.zero? or this_blog.allow_signup == 1
      redirect_to :action => 'login'
      return
    end

    @user = User.new(params[:user])

    if request.post? and @user.save
      self.current_user = @user
      session[:user_id] = @user.id
      flash[:notice]  = _("Signup successful")
      redirect_to :controller => "admin/settings", :action => "index"
      return
    end
  end

  def logout
    flash[:notice]  = _("Successfully logged out")
    self.current_user.forget_me
    self.current_user = nil
    session[:user_id] = nil
    cookies.delete :auth_token
    cookies.delete :typo_user_profile
    redirect_to :action => 'login'
  end

  private

  def verify_users
    redirect_to(:controller => "accounts", :action => "signup") if User.count == 0
    true
  end

end
