# coding: utf-8
module AccountsHelper
  def lost_password
    link_to(content_tag(:small, _("I've lost my password")), :action => 'recover_password')
  end
  
  def create_account_link
    link_to(content_tag(:small, _("Create an account")), :action => 'signup') if this_blog.allow_signup == 1
  end

  def back_to_login
    link_to(content_tag(:small, _("Back to login")), :action => 'login')
  end
end
