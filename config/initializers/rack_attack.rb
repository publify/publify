# frozen_string_literal: true

# Throttle login attempts
Rack::Attack.throttle("logins/ip", limit: 20, period: 1.hour) do |req|
  req.ip if req.post? && req.path.start_with?("/users/sign_in")
end

# Throttle password reset attempts
Rack::Attack.throttle("password-reset-requests/ip", limit: 20, period: 1.hour) do |req|
  req.ip if req.post? && req.path.start_with?("/users/password")
end

ActiveSupport::Notifications.
  subscribe("rack.attack") do |_name, _start, _finish, _request_id, req|
  Rails.logger.info "Throttled #{req.env["rack.attack.match_discriminator"]}"
end
