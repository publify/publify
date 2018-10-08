# frozen_string_literal: true

module ThemeHelper
  # Adds per theme helpers if file exists. Ugly but at least it works.
  # Use: just add your methods in yourtheme/helpers/theme_helper.rb
  # If your theme is a plugin, it's better to just load relevant helpers in the
  # initialization code instead.
  Theme.find_all.each do |theme|
    filename = File.join(theme.path, 'helpers', 'theme_helper.rb')
    require filename if File.exist? filename
  end
end
