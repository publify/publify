Mailjet.configure do |config|
  config.api_key = ENV["MAILJET_API_KEY"]
  config.secret_key = ENV["MAILJET_SECRET_KEY"]
  config.default_from = ENV["MAILJET_DEFAULT_FROM_ADDRESS"]
end
