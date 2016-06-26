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

    private

    def registered_sidebars
      @registered_sidebars ||= Set.new
    end
  end
end
