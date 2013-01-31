module Admin::ResourcesHelper
  def resource_action_links(resource)
    links ||= []
    if resource.mime =~ /image/
      links = [ link_to(_("Thumbnail"), resource.upload.thumb.url),
                link_to(_("Medium size"), resource.upload.medium.url),
                link_to(_("Original size"), resource.upload.url)]
    end
    links << link_to(_("delete"), { :action => 'destroy', :id => resource.id, :search => params[:search], :page => params[:page] },  :confirm => _("Are you sure?"), :method => :post)
    content_tag :small do
      links.join(" | ").html_safe
    end
  end
end
