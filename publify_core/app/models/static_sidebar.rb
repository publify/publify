# frozen_string_literal: true

class StaticSidebar < SidebarConfiguration
  DEFAULT_TEXT = <<~TEXT
    <ul>
      <li><a href="https://publify.github.io/" title="Publify">Publify</a></li>
      <li><a href="http://t37.net/" title="Le Rayon UX">Frédéric</a></li>
      <li><a href="http://www.matijs.net/" title="Matijs">Matijs</a></li>
      <li><a href="http://elsif.fr/" title="Yannick">Yannick</a></li>
      <li><a href="http://blog.ookook.fr/" title="Thomas">Thomas</a></li>
      <li><a href="/admin">Admin</a></li>
    </ul>
  TEXT

  description "Static content, like links to other sites, advertisements," \
              " or blog meta-information"

  setting :title, "Links"
  setting :body, DEFAULT_TEXT, input_type: :text_area
end

SidebarRegistry.register_sidebar StaticSidebar
