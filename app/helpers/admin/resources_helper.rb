module Admin::ResourcesHelper
  def show_thumbnail(image)
    image.create_thumbnail
    "<img class='tumb' src='#{this_blog.base_url}/files/thumb_#{image.filename}' alt='#{this_blog.base_url}/files/#{image.filename}' />"
  end

  def resource_action_links upload
    links ||= []
    if upload.mime =~ /image/
      links = [ link_to(_("Thumbnail"), "#{this_blog.base_url}/files/thumb_#{upload.filename}"),
                link_to(_("Medium size"), "#{this_blog.base_url}/files/medium_#{upload.filename}"),
                link_to(_("Original size"), "#{this_blog.base_url}/files/#{upload.filename}")]
    end
      links << link_to(_("delete"), {:action => 'destroy', :id => upload.id, :search => params[:search], :page => params[:page] },  :confirm => _("Are you sure?"), :method => :post)
    content_tag :small do 
      links.join(" | ").html_safe
    end    
  end

end
