# frozen_string_literal: true

class MetaSidebar < SidebarConfiguration
  description "This widget just displays links to Publify main site," \
              " this blog's admin and RSS."

  setting :title, "Meta"
end

SidebarRegistry.register_sidebar MetaSidebar
