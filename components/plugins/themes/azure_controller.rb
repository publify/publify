class Plugins::Themes::AzureController < Themes::Plugin
  uses_component_template_root

  def self.themename
    "azure"
  end
end
