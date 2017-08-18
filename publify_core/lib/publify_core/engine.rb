module PublifyCore
  class Engine < ::Rails::Engine
    config.generators do |generators|
      generators.test_framework :rspec, fixture: false
      generators.fixture_replacement :factory_girl, dir: 'spec/factories'
    end

    config.to_prepare do
      DeviseController.layout 'accounts'
    end

    initializer 'publify_core.assets.precompile' do |app|
      app.config.assets.precompile += %w(
        publify.js
        publify.css
        publify_admin.js
        publify_admin.css
        accounts.css
        bootstrap.css
        user-styles.css
        coderay.css
        spinner-blue.gif
        spinner.gif
      )
    end
  end
end
