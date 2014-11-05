if Rails.env.in?(%(test cucumber))
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
    if ENV['provider'] == 'Rackspace'
      config.storage = :fog

      config.fog_credentials = {
        provider:           'Rackspace',
        rackspace_username: ENV['rackspace_username'],
        rackspace_api_key:  ENV['rackspace_api_key'],
        rackspace_auth_url: Fog::Rackspace::UK_AUTH_ENDPOINT,
        rackspace_region:   :lon
      }

      config.fog_directory = ENV['rackspace_directory']
      config.asset_host = ENV['rackspace_cnd_host']
    else
      config.storage = :file
      config.permissions = 0666
      config.directory_permissions = 0777
    end
  end
end
