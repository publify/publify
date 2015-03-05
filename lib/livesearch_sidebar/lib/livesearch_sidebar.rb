class LivesearchSidebar < Sidebar
  description 'Adds livesearch to your Publify blog'

  setting :title, 'Search'
end

Sidebar.register_sidebar LivesearchSidebar
