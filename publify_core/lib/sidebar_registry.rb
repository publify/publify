class SidebarRegistry
  class << self
    def register_sidebar(klass_name)
      registered_sidebars << klass_name.to_s
    end

    def available_sidebars
      registered_sidebars.sort.map(&:constantize)
    end

    def available_sidebar_types
      registered_sidebars.sort
    end

    def register_sidebar_directory(plugins_root, paths)
      separator = plugins_root.include?('/') ? '/' : '\\'

      Dir.glob(File.join(plugins_root, '*_sidebar')).select do |file|
        plugin_name = file.split(separator).last
        register_sidebar plugin_name.classify
        # TODO: Move Sidebars to app/models, and views to app/views so this can
        # be simplified.
        paths << File.join(plugins_root, plugin_name, 'lib')
      end
    end

    private

    def registered_sidebars
      @registered_sidebars ||= Set.new
    end
  end
end
