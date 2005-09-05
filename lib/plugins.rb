module TypoPlugins
  def plugin_public_action(action)
    @@plugin_public_actions ||= []
    @@plugin_public_actions.push action
  end

  def plugin_public_actions
    @@plugin_public_actions
  end
end