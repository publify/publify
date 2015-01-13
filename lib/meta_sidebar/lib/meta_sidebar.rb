# coding: utf-8
class MetaSidebar < Sidebar
  description "This widget just displays links to Publify main site, this blog's admin and RSS."

  setting :title, 'Meta'
end

Sidebar.register_sidebar MetaSidebar
