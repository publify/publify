module TypoPlugins
  def plugin_public_action(action)
    @@plugin_public_actions ||= []
    @@plugin_public_actions.push action
  end

  def plugin_public_actions
    @@plugin_public_actions
  end
  
  def plugin_description(description)
    @@plugin_description = description
  end
  
  def plugin_display_name(name)
    @@plugin_display_name = name
  end
end