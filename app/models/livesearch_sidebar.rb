class LivesearchSidebar < Sidebar
  description 'Adds livesearch to your Publify blog'

  setting :title, 'Search'
end

SidebarRegistry.register_sidebar LivesearchSidebar
