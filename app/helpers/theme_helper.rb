module ThemeHelper
  # adds per theme helpers if file exists. Ugly but at least it works.
  # Use : just add your methods in yourtheme/helpers/theme_helper.rb
  require "#{Blog.default.current_theme.path}/helpers/theme_helper.rb" if File.exists? "#{Blog.default.current_theme.path}/helpers/theme_helper.rb"
end
