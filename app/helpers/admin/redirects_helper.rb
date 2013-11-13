module Admin::RedirectsHelper
  def show_redirect_actions item
    content_tag(:div, {:class => 'action'}) do
      [ button_to_edit(item),
        button_to_delete(item) ].join(" ").html_safe
    end    
  end
end
