require 'publify_plugins'
require 'text_filter_plugin'

plugins_root = File.join(::Rails.root.to_s, 'lib')
separator = plugins_root.include?('/') ? '/' : '\\'

Dir.glob(File.join(plugins_root, '*_textfilter_*')).select do |file|
  require file.split(separator).last.gsub('.rb', '')
end
