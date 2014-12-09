require_relative "production"

Rails.application.configure do
  config.assets.prefix = "/staging-assets"
end
