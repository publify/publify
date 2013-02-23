module Admin::PostTypesHelper
  def show_post_types_actions item
    content_tag(:div, {:class => 'action'}) do
      [ small_to_edit(item), 
        small_to_delete(item)
        ].join(" | ").html_safe
    end
  end
end
