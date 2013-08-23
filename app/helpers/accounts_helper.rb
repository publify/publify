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
  
  def back_home
    link_to(content_tag(:small, _("&larr; Back to %s", this_blog.blog_name).html_safe), this_blog.base_url)
  end
  
  def link_to_publify
    content_tag(:h1, link_to("Publify", "http://publify.co"))
  end
end
