# frozen_string_literal: true

module Admin::FeedbackHelper
  def comment_class(state)
    return "label-info" if state.to_s.casecmp("presumed_ham").zero?
    return "label-warning" if state.to_s.casecmp("presumed_spam").zero?
    return "label-success" if state.to_s.casecmp("ham").zero?

    "label-danger"
  end

  def show_feedback_actions(item, context = "listing")
    return unless can? :manage, "admin/feedback"

    safe_join [
      change_status(item, context),
      button_to_edit_comment(item),
      button_to_delete_comment(item),
      button_to_conversation(item),
    ], " "
  end

  def button_to_edit_comment(item)
    link_to(t("generic.edit"),
            { controller: "admin/feedback", action: "edit", id: item.id },
            { class: "btn btn-primary btn-xs btn-action" })
  end

  def button_to_delete_comment(item)
    link_to(t("generic.delete"),
            { controller: "admin/feedback", action: "destroy", id: item.id },
            { class: "btn btn-danger btn-xs btn-action" })
  end

  def button_to_conversation(item)
    link_to(t("generic.conversation"),
            { controller: "admin/feedback", action: "article", id: item.article_id },
            { class: "btn btn-default btn-xs btn-action" })
  end

  def change_status(item, context = "listing")
    spammy = item.state.to_s.downcase.include? "spam"
    link_text = spammy ? t("generic.mark_as_ham") : t("generic.mark_as_spam")
    button_type = spammy ? "success" : "warning"

    link_to(link_text,
            { controller: "admin/feedback", action: "change_state",
              id: item.id, context: context },
            { class: "btn btn-#{button_type} btn-xs btn-action",
              method: :post, remote: true })
  end
end
