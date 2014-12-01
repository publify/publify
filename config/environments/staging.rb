require_relative "production"

Rails.application.configure do
  config.action_mailer.default_url_options = { host: 'blog-staging.moneyadviceservice.org.uk' }
end
