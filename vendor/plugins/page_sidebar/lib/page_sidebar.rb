class PageSidebar < Sidebar
  display_name "Page"
  description "Show pages for this blog"

  setting :maximum_pages, 10

  def pages
    @pages ||= Page.published.order(:title)
  end
end
