# frozen_string_literal: true

module PublifyCore
  class Engine < ::Rails::Engine
    config.generators do |generators|
      generators.test_framework :rspec, fixture: false
      generators.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    config.to_prepare do
      DeviseController.layout "accounts"
      DeviseController.before_action do
        devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
      end
    end

    initializer "publify_core.assets.precompile" do |app|
      app.config.assets.precompile += %w(
        publify.js
        publify.css
        publify_admin.js
        publify_admin.css
        accounts.css
        user-styles.css
        spinner-blue.gif
        spinner.gif
      )
    end
  end
end
