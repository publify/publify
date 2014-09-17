class SidebarGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def copy_stuff
    template 'init.rb',       "#{plugin_path}/init.rb"
    template 'sidebar.rb',    "#{plugin_path}/lib/#{file_name}.rb"
    template 'unit_test.rb',  "#{plugin_path}/test/#{file_name}_test.rb"
    template 'Rakefile',      "#{plugin_path}/Rakefile"
    template 'content.html.erb', "#{plugin_path}/views/content.html.erb"
  end

  private

  def plugin_path
    @plugin_path ||= "lib/#{file_name}"
  end
end
