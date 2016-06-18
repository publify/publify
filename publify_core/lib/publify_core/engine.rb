module PublifyCore
  class Engine < ::Rails::Engine
    config.generators do |generators|
      generators.test_framework :rspec, fixture: false
      generators.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  end
end
