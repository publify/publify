# coding: utf-8
module AccountsHelper
  def lost_password
    link_to("<small> • #{_("I've lost my password")}</small>".html_safe, :action => 'recover_password').html_safe
  end
  
  def create_account_link
    link_to("<small>#{_("Create an account")}</small>".html_safe, :action => 'signup') if this_blog.allow_signup == 1
  end

  def back_to_login
    link_to("<small>#{_("Back to login")}</small>".html_safe, :action => 'login')
  end
end
