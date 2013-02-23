module Admin::TagHelper
  def show_tag_actions item
    content_tag(:div, {:class => 'action'}) do
      [ content_tag(:small, link_to_permalink(item, _("Show"))), 
        small_to_edit(item),
        small_to_delete(item),
        ].join(" | ").html_safe
    end    
  end
end
