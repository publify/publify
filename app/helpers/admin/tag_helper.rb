module Admin::TagHelper
  def show_tag_actions item
    html = <<-HTML
      <div class='action'>
        <small>#{link_to_permalink item, _("Show")}</small> |
        <small>#{link_to _("Edit"), :action => 'edit', :id => item.id}</small> |
        <small>#{link_to _("Delete"), :action => 'destroy', :id => item.id}</small>
    </div>
    HTML
  end
end
