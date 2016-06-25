class SidebarRegistry
  class << self
    def register_sidebar(klass)
      registered_sidebars << klass
      @available_sidebar_types = nil
    end

    def available_sidebars
      registered_sidebars.sort_by(&:to_s)
    end

    def available_sidebar_types
      registered_sidebars.map(&:to_s).sort
    end

    private

    def registered_sidebars
      @registered_sidebars ||= []
    end
  end
end
