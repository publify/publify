module Admin::FeedbackHelper
  def comment_class state
    (state.to_s.downcase =~ /spam/) ? 'unpublished' : 'published'
  end

  def show_feedback_actions(item, context='listing')
    html = <<-HTML
      <div class='action'>
        #{published_or_not item} |
        #{change_status(item, context)} |
        #{link_to _("Edit"), :controller => 'admin/feedback', :action => 'edit', :id => item.id} |
        #{link_to _("Delete"), :controller => 'admin/feedback', :action => 'destroy', :id => item.id }|
        #{link_to _("Show conversation"), :controller => 'admin/feedback', :action => 'article', :id => item.article_id}
    </div>
    HTML
  end

  def change_status(item, context='listing')
    status = (item.state == :spam) ? :ham : :spam
    link_to_remote(_("Flag as %s", status.to_s), :url => {:controller => 'admin/feedback',:action => 'change_state', :id => item.id, :context => context})
  end
end
