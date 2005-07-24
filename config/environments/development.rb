require 'active_support/whiny_nil'

Dependencies.mechanism                             = :load
ActionController::Base.consider_all_requests_local = true
ActionController::Base.perform_caching             = false
Migrator.offer_migration_when_available            = true
BREAKPOINT_SERVER_PORT = 42531