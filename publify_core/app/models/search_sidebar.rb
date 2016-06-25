# frozen_string_literal: true

class SearchSidebar < SidebarConfiguration
  description "Adds basic search sidebar in your Publify blog"

  setting :title, "Search"
end

SidebarRegistry.register_sidebar SearchSidebar
