class SidebarGenerator < Rails::Generator::NamedBase
  attr_reader :plugin_path

  def initialize(runtime_args, runtime_options = { })
    super
    @plugin_path = "lib/#{file_name}"
  end

  def manifest
    record do |m|
      m.directory "#{plugin_path}/lib"
      m.directory "#{plugin_path}/test"
      m.directory "#{plugin_path}/views"

      m.template 'init.rb',       "#{plugin_path}/init.rb"
      m.template 'sidebar.rb',    "#{plugin_path}/lib/#{file_name}.rb"
      m.template 'unit_test.rb',  "#{plugin_path}/test/#{file_name}_test.rb"
      m.template 'Rakefile',      "#{plugin_path}/Rakefile"
      m.template 'content.rhtml', "#{plugin_path}/views/content.rhtml"
    end
  end
end
