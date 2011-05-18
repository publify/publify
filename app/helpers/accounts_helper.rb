module AccountsHelper
  def display_accounts_link
    html = ""
    html << link_to("<small>&raquo; #{_("Create an account")}</small><br />".html_safe, :action => 'signup') if this_blog.allow_signup == 1
    html << link_to("<small>&raquo; #{_('Back to ')} #{this_blog.blog_name}</small><br />".html_safe, this_blog.base_url)
    html << link_to("<small>&raquo; #{_("I've lost my password")}</small>".html_safe, :action => 'recover_password')
    html.html_safe
  end
  
end
