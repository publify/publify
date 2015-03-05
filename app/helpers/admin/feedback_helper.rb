module Admin::FeedbackHelper
  def comment_class(state)
    return 'label-info' if state.to_s.downcase == 'presumed_ham'
    return 'label-warning' if state.to_s.downcase == 'presumed_spam'
    return 'label-success' if state.to_s.downcase == 'ham'
    'label-danger'
  end

  def show_feedback_actions(item, context = 'listing')
    return if current_user.profile.label == 'contributor'
    content_tag(:div,  class: 'action', style: '') do
      [content_tag(:small, change_status(item, context)),
       button_to_edit_comment(item),
       button_to_delete_comment(item),
       button_to_conversation(item)
      ].join(' ').html_safe
    end
  end

  def button_to_edit_comment(item)
    link_to(content_tag(:span, '', class: 'glyphicon glyphicon-pencil'), { controller: 'admin/feedback', action: 'edit', id: item.id }, { class: 'btn btn-primary btn-xs btn-action' })
  end

  def button_to_delete_comment(item)
    link_to(content_tag(:span, '', class: 'glyphicon glyphicon-trash'), { controller: 'admin/feedback', action: 'destroy', id: item.id }, { class: 'btn btn-danger btn-xs btn-action' })
  end

  def button_to_conversation(item)
    link_to(content_tag(:span, '', class: 'glyphicon glyphicon-share-alt'), { controller: 'admin/feedback', action: 'article', id: item.article_id }, { class: 'btn btn-default btn-xs btn-action' })
  end

  def change_status(item, context = 'listing')
    spammy = item.state.to_s.downcase =~ /spam/
    direction = spammy ? 'up' : 'down'
    button_type = spammy ? 'success' : 'warning'

    link_to(content_tag(:span, '', class: "glyphicon glyphicon-thumbs-#{direction}"),
            { controller: 'admin/feedback', action: 'change_state', id: item.id, context: context },
            { class: "btn btn-#{button_type} btn-xs btn-action", remote: true })
  end
end
