if Rails.env.in?(%(test cucumber))
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
    if ENV['FOG_PROVIDER'] == 'Rackspace'
      config.storage = :fog

      config.fog_credentials = {
        provider:           ENV['FOG_PROVIDER'],
        rackspace_username: ENV['RACKSPACE_USERNAME'],
        rackspace_api_key:  ENV['RACKSPACE_API_KEY'],
        rackspace_auth_url: Fog::Rackspace::UK_AUTH_ENDPOINT,
        rackspace_region:   :lon
      }

      config.fog_directory = ENV['FOG_DIRECTORY']
      config.asset_host = ENV['RACKSPACE_CDN_HOST']
    else
      config.storage = :file
      config.permissions = 0666
      config.directory_permissions = 0777
    end
  end
end
