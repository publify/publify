module PublifyCore
  class Engine < ::Rails::Engine
    config.generators do |generators|
      generators.test_framework :rspec, fixture: false
    end
  end
end
