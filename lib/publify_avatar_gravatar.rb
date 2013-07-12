require File.join(Rails.root, 'lib', 'publify_plugins.rb')
require File.join(Rails.root, 'lib', 'avatar_plugin.rb')
require File.join(Rails.root, 'lib', 'publify_avatar_gravatar', 'lib', 'publify_avatar_gravatar.rb')

PublifyPlugins::Keeper.register(PublifyPlugins::Gravatar)
