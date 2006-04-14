module SidebarHelper
  def render_sidebar(sidebar)
    begin
      # another ugly ugly hack like in articles_helper.rb
      options = { :layout => false,
                  :controller => sidebar.sidebar_controller,
                  :action=>'index',
                  :params => params.merge({:sidebar => sidebar}) }

      render_component(options)
    rescue => e
      content_tag :p, e.message, :class => 'error'
    end
  end

  def page_header
    javascript_include_tag("cookies") +
      javascript_include_tag("prototype") +
      javascript_include_tag("effects") +
      javascript_include_tag("type")
  end
end
