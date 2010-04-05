module Admin::FeedbackHelper
  def comment_class state
    (state.to_s =~ /Ham/) ? 'published' : 'unpublished'
  end

  def show_actions item
    html = <<-HTML 
      <div class='action' style='margin-top: 10px;'>
        <small>#{link_to _("Show conversation"), :controller => 'feedback', :action => 'article', :id => item.article_id}</small> |
        <small>#{link_to _("Delete"), :action => 'destroy', :id => item.id}</small>
    </div>
    HTML
  end

end
