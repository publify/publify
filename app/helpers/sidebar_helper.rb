module SidebarHelper
  def render_sidebars
    this_blog.sidebars.inject('') do |acc, sb|
      @sidebar = sb
      sb.parse_request(contents, params)
      controller.response.lifetime = sb.lifetime if sb.lifetime
      acc + render_sidebar(sb)
    end
  end

  def render_sidebar(sidebar)
    if sidebar.view_root
      render_to_string(:file => "#{sidebar.view_root}/content.rhtml",
                       :locals => sidebar.to_locals_hash)
    else
      render_to_string(:partial => sidebar.content_partial,
                       :locals => sidebar.to_locals_hash)
    end
  end

end
