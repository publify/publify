# config/initializers/timeout.rb
if Rails.env.production?
  Rack::Timeout.timeout = 10  # seconds
end