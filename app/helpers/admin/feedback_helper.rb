module Admin::FeedbackHelper
  def comment_class state
    return 'notice' if state.to_s.downcase == 'ham?'
    return 'warning' if state.to_s.downcase == 'spam?'
    return 'success' if state.to_s.downcase == 'ham'
    return 'important'
  end

  def show_feedback_actions(item, context='listing')
    html = <<-HTML
      <small>
        
        #{published_or_not item} |
        #{change_status(item, context)} |
        #{link_to _("Edit"), :controller => 'admin/feedback', :action => 'edit', :id => item.id} |
        #{link_to _("Delete"), :controller => 'admin/feedback', :action => 'destroy', :id => item.id }|
        #{link_to _("Show conversation"), :controller => 'admin/feedback', :action => 'article', :id => item.article_id}
    </small>
    HTML
  end

  def filter_link(text, filter='', style='')
    
    return content_tag(:span, text, {:class => 'label'}) unless [params[:published], params[:confirmed], params[:ham], params[:spam], params[:presumed_ham], params[:presumed_spam]].include?('f')
  end

  def change_status(item, context='listing')
    status = (item.state == :spam) ? :ham : :spam
    link_to_remote(_("Flag as %s", status.to_s), :url => {:controller => 'admin/feedback',:action => 'change_state', :id => item.id, :context => context})
  end
end
