module Admin::FeedbackHelper
  def comment_class state
    return 'badge-info' if state.to_s.downcase == 'ham?'
    return 'badge-warning' if state.to_s.downcase == 'spam?'
    return 'badge-success' if state.to_s.downcase == 'ham'
    return 'badge-important'
  end

  def show_feedback_actions(item, context='listing')
    return if current_user.profile.label == "contributor"
    content_tag(:small) do
      [change_status(item, context),
        content_tag(:small, link_to(_("Edit"), :controller => 'admin/feedback', :action => 'edit', :id => item.id)),
        content_tag(:small, link_to(_("Delete"), {:controller => 'admin/feedback', :action => 'destroy', :id => item.id}, {:class => 'delete'})),
        link_to(_("Show conversation"), :controller => 'admin/feedback', :action => 'article', :id => item.article_id)].join(" | ").html_safe
    end      
  end

  def filter_link(text, filter='', style='')
    return content_tag(:span, text, {:class => 'label'}) unless [params[:published], params[:confirmed], params[:ham], params[:spam], params[:presumed_ham], params[:presumed_spam]].include?('f')
  end

  def change_status(item, context='listing')
    status = (item.state.to_s.downcase =~ /spam/) ? :ham : :spam
    link_to_remote(_("Flag as %s", status.to_s), :url => {:controller => 'admin/feedback',:action => 'change_state', :id => item.id, :context => context})
  end
end
