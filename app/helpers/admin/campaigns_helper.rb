module Admin::CampaignsHelper
  def show_actions_for_campaign item
    content_tag(:div, class: 'action', style: '') do
      [button_to_edit(item),
        button_to_delete(item)].join(' ').html_safe
    end
  end
end
