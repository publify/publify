module Admin::DashboardHelper
  def dashboard_action_links
    links = []
    links << link_to(t('.write_a_post'), controller: 'content', action: 'new') if current_user.can_access_to_articles?
    links << link_to(t('.write_a_page'), controller: 'pages', action: 'new') if current_user.can_access_to_pages?
    links << link_to(t(".update_your_profile_or_change_your_password"), controller: 'profiles', action: 'index')
    links.join(', ')
  end
end
