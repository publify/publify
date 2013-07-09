require File.join(Rails.root, 'lib', 'typo_plugins.rb')

PublifyPlugins.module_eval do
  def self.convert_from(engine, options = {})
    require "converters/base"
    require "converters/#{engine}"
    puts "converting #{engine.to_s.humanize}..."
    "#{engine.to_s.camelize}Converter".constantize.convert(options)
  end
end
