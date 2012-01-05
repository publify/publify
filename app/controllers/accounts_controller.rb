class AccountsController < ApplicationController

  before_filter :verify_config
  before_filter :verify_users, :only => [:login, :recover_password]

  def index
    if User.count.zero?
      redirect_to :action => 'signup'
    else
      redirect_to :action => 'login'
    end
  end

  def login
    if session[:user_id] && session[:user_id] == self.current_user.id
      redirect_back_or_default :controller => "admin/dashboard", :action => "index"
      return
    end

    @page_title = "#{this_blog.blog_name} - #{_('login')}"

    if request.post?
      self.current_user = User.authenticate(params[:user][:login], params[:user][:password])

      if logged_in?
        session[:user_id] = self.current_user.id

        if params[:remember_me] == "1"
          self.current_user.remember_me unless self.current_user.remember_token?
          cookies[:auth_token] = {
            :value => self.current_user.remember_token,
            :expires => self.current_user.remember_token_expires_at,
            :httponly => true # Help prevent auth_token theft.
          }
        end
        add_to_cookies(:typo_user_profile, self.current_user.profile_label, '/')

        self.current_user.update_connection_time
        flash[:notice]  = _("Login successful")
        redirect_back_or_default :controller => "admin/dashboard", :action => "index"
      else
        flash.now[:error]  = _("Login unsuccessful")
        @login = params[:user][:login]
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

    if request.post?
      @user.password = generate_password
      session[:tmppass] = @user.password
      @user.name = @user.login
      if @user.save
        self.current_user = @user
        session[:user_id] = @user.id

        redirect_to :controller => "accounts", :action => "confirm"
        return
      end
    end
  end

  def recover_password
    @page_title = "#{this_blog.blog_name} - #{_('Recover your password')}"
    if request.post?
      @user = User.find(:first, :conditions => ["login = ? or email = ?", params[:user][:login], params[:user][:login]])

      if @user
        @user.password = generate_password
        @user.save
        flash[:notice] = _("An email has been successfully sent to your address with your new password")
        redirect_to :action => 'login'
      else
        flash[:error] = _("Oops, something wrong just happened")
      end
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
  def generate_password
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(7) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  def verify_users
    redirect_to(:controller => "accounts", :action => "signup") if User.count == 0
    true
  end

  def verify_config
    redirect_to :controller => "setup", :action => "index" if  ! this_blog.configured?
  end
end
