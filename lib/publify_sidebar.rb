plugins_root = File.join(::Rails.root.to_s, 'lib')
separator = plugins_root.include?('/') ? '/' : '\\'

Dir.glob(File.join(plugins_root, '*_sidebar')).select do |file|
  plugin_name = file.split(separator).last
  require File.join(plugin_name, 'lib', plugin_name)
end
