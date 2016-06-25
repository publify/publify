# coding: utf-8
class MetaSidebar < Sidebar
  description "This widget just displays links to Publify main site, this blog's admin and RSS."

  setting :title, 'Meta'
end

SidebarRegistry.register_sidebar MetaSidebar
