require 'sidebar_registry'

plugins_root = File.join(::Rails.root.to_s, 'lib')
SidebarRegistry.register_sidebar_directory(plugins_root, Rails.application.config.autoload_paths)
