module Admin::DashboardHelper
  def dashboard_theme_link
    return unless current_user.can_access_to_themes?
    _("You can also do a bit of design, %s or %s." ,
      link_to(_("change your blog presentation"), :controller => 'themes') ,
      link_to(_("enable plugins"), :controller => 'sidebar'))
  end

  def dashboard_sidebar_link
    return unless current_user.can_access_to_customizesidebar?
    _("You can also %s to customize your Publify blog.",
      link_to(_('download some plugins'), 'http://plugins.publify.co'))
  end

  def dashboard_action_links
    links = []

    links << link_to(_('write a post'), :controller => 'content', :action => 'new') if current_user.can_access_to_articles?
    links << link_to(_('write a page'), :controller => 'pages', :action => 'new') if current_user.can_access_to_pages?
    links << link_to(_("update your profile or change your password"), :controller => 'profiles', :action => 'index') if current_user.can_access_to_profile?

    links.join(', ')
  end
end
