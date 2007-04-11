module SidebarHelper
  def render_sidebars(*sidebars)
    (sidebars.blank? ? this_blog.sidebars : sidebars).inject('') do |acc, sb|
      @sidebar = sb
      sb.parse_request(contents, params)
      controller.response.lifetime = sb.lifetime if sb.lifetime
      acc + render_sidebar(sb)
    end
  end

  def render_sidebar(sidebar)
    if sidebar.view_root
      # Allow themes to override sidebar views
      view_root = File.expand_path(sidebar.view_root)
      rails_root = File.expand_path(RAILS_ROOT)
      if view_root =~ /^#{Regexp.escape(rails_root)}/
        new_root = view_root[rails_root.size..-1]
        new_root.sub! %r{^/?vendor/}, ""
        new_root.sub! %r{/views}, ""
        new_root = File.join(this_blog.current_theme.path, "views", new_root)
        view_root = new_root if File.exists?(File.join(new_root, "content.rhtml"))
      end
      render_to_string(:file => "#{view_root}/content.rhtml",
                       :locals => sidebar.to_locals_hash)
    else
      render_to_string(:partial => sidebar.content_partial,
                       :locals => sidebar.to_locals_hash)
    end
  end

end
