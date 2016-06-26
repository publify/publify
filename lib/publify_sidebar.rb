require 'sidebar_registry'

plugins_root = File.join(::Rails.root.to_s, 'lib')
separator = plugins_root.include?('/') ? '/' : '\\'

Dir.glob(File.join(plugins_root, '*_sidebar')).select do |file|
  plugin_name = file.split(separator).last
  SidebarRegistry.register_sidebar plugin_name.classify
  Rails.application.config.autoload_paths << File.join(plugins_root, plugin_name, 'lib')
end
