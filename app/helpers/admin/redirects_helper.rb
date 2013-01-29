module Admin::RedirectsHelper
  def show_redirect_actions item
    content_tag(:div, {:class => 'action'}) do
      [ content_tag(:small, link_to(_("Edit"), :action => 'edit', :id => item.id)), 
        content_tag(:small, link_to(_("Delete"), :action => 'destroy', :id => item.id))
        ].join(" | ").html_safe
    end    
  end
end
