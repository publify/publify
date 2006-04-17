class SidebarGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.class_collisions class_name

      m.template "components/plugins/sidebars/controller_template.rb",
                 "components/plugins/sidebars/#{file_name}_controller.rb"
      m.directory File.join('components/plugins/sidebars', file_name)
      m.template "components/plugins/sidebars/views/content_template.rhtml",
                 "components/plugins/sidebars/#{file_name}/content.rhtml"
    end
  end
end
