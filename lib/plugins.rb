module TypoPlugins
  def plugin_public_action(action)
    @@plugin_public_actions ||= []
    @@plugin_public_actions.push action
  end

  def plugin_public_actions
    @@plugin_public_actions
  end

  def plugin_description(description)
    eval "def self.description; '#{description}'; end"

  end

  def plugin_display_name(name)
    eval "def self.display_name; '#{name}'; end"
  end
end
