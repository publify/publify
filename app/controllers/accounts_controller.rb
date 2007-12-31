class AccountsController < ApplicationController

  before_filter :verify_users, :only => [:login]

  def login
    case request.method
      when :post
      if user = User.authenticate(params[:user_login], params[:user_password])
        session[:user_id] = user.id

        flash[:notice]  = "Login successful"
        cookies[:is_admin] = "yes"
        redirect_back_or_default :controller => "admin/dashboard", :action => "index"
      else
        flash.now[:notice]  = "Login unsuccessful"

        @login = params[:user_login]
      end
    end
  end

  def signup
    unless User.count.zero?
      redirect_to :action => 'login'
      return
    end

    @user = User.new(params[:user])

    if request.post? and @user.save
      session[:user_id] = @user.id
      flash[:notice]  = "Signup successful"
      redirect_to :controller => "admin/settings", :action => "index"
      return
    end
  end

  def logout
    session[:user_id] = nil
    cookies.delete :is_admin
  end

  def welcome
  end

  private

  def verify_users
    if User.count == 0
      redirect_to :controller => "accounts", :action => "signup"
    else
      true
    end
  end

end
