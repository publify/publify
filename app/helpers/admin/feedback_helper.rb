module Admin::FeedbackHelper
  def comment_class state
    (state.to_s =~ /Ham/) ? 'published' : 'unpublished'
  end

  def show_actions item
    html = <<-HTML 
      <div class='action'>
        #{link_to _("Show conversation"), :controller => 'feedback', :action => 'article', :id => item.article_id} |
        #{change_status item} |
        #{link_to _("Delete"), :action => 'destroy', :id => item.id}|
        #{published_or_not item}
    </div>
    HTML
  end

  def change_status item
    status = (item.state == :spam) ? :ham : :spam
    link_to_remote(_("Flag as %s", status.to_s), :url => {:action => 'change_state', :id => item.id})
  end
end
