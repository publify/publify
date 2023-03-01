# frozen_string_literal: true

class LivesearchSidebar < SidebarConfiguration
  description "Adds livesearch to your Publify blog"

  setting :title, "Search"
end

SidebarRegistry.register_sidebar LivesearchSidebar
