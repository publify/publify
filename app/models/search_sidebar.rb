class SearchSidebar < Sidebar
  description 'Adds basic search sidebar in your Publify blog'

  setting :title, 'Search'
end

SidebarRegistry.register_sidebar SearchSidebar
