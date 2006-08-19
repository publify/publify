module SidebarHelper
  def page_header
    javascript_include_tag("cookies") +
      javascript_include_tag("prototype") +
      javascript_include_tag("effects") +
      javascript_include_tag("type")
  end
end
