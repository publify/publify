module ThemeHelper

  # NB: This overrides an undocumented rails function in order to add
  # a search path. We need this to get themes working, but I'd be
  # happier if we didn't have to override undocumented methods. Ho
  # hum. -- pdcawley

#   def search_paths
#     ["../themes/#{this_blog.theme}/views",     # for components
#      "../../themes/#{this_blog.theme}/views",  # for normal views
#      ".",
#      "../app/views"]
#   end

#   def full_template_path(template_path, extension)
#     search_paths.each do |path|
#       themed_path = File.join(view_paths.first, path, "#{template_path}.#{extension}")
#       return themed_path if File.exist?(themed_path)
#     end
#     # Can't find a themed version, so fall back to the default behaviour
#     super
#   end
end
