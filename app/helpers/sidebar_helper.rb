module SidebarHelper
  def render_sidebars(*sidebars)
    begin
      (sidebars.blank? ? Sidebar.find(:all, :order => 'active_position ASC') : sidebars).map do |sb|
        @sidebar = sb
        sb.parse_request(content_array, params)
        render_sidebar(sb)
      end.join
    rescue => e
      logger.error e
      _("It seems something went wrong. Maybe some of your sidebars are actually missing and you should either reinstall them or remove them manually
        ")
    end
  end

  def render_sidebar(sidebar)
    if sidebar.view_root
      render_deprecated_sidebar_view_in_view_root sidebar
    else
      render_to_string(:partial => sidebar.content_partial,
                       :locals => sidebar.to_locals_hash,
                       :layout => false)
    end
  end

  def render_deprecated_sidebar_view_in_view_root(sidebar)
    logger.warn "Sidebar#view_root is deprecated. Place your _content.html.erb in views/sidebar_name/ in your plugin's folder"
    # Allow themes to override sidebar views
    view_root = File.expand_path(sidebar.view_root)
    rails_root = File.expand_path(::Rails.root.to_s)
    if view_root =~ /^#{Regexp.escape(rails_root)}/
      new_root = view_root[rails_root.size..-1]
      new_root.sub! %r{^/?vendor/}, ""
      new_root.sub! %r{/views}, ""
      new_root = File.join(this_blog.current_theme.path, "views", new_root)
      view_root = new_root if File.exists?(File.join(new_root, "content.rhtml"))
    end
    render_to_string(:file => "#{view_root}/content.rhtml",
                     :locals => sidebar.to_locals_hash,
                     :layout => false)
  end

  def articles?
    not Article.first.nil?
  end

  def trackbacks?
    not Trackback.first.nil?
  end

  def comments?
    not Comment.first.nil?
  end

end
