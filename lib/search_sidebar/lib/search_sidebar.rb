class SearchSidebar < Sidebar
  description 'Adds basic search sidebar in your Publify blog'

  setting :title, 'Search'
end

Sidebar.register_sidebar SearchSidebar
