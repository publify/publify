module Sidebars
  class Sidebars::ComponentPlugin < Sidebars::Plugin
    self.template_root = File.join RAILS_ROOT, "components"
  end
end
