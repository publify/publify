module Admin::TagHelper
  def show_actions item
    html = <<-HTML
      <div class='action' style='margin-top: 10px;'>
        <small>#{link_to _("Edit"), :action => 'edit', :id => item.id}</small> |
        <small>#{link_to_permalink item, _("show")}</small> |
        <small>#{link_to _("Delete"), :action => 'destroy', :id => item.id}</small>
    </div>
    HTML
  end
end