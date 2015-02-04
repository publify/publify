require_relative 'page'
require 'google/api_client'

module GoogleAnalytics
  class API
    def self.fetch_article_page_views
      user = Legato::User.new new_oauth2_token
      profile = user.profiles.first

      results = GoogleAnalytics::Page.popular_articles(profile)
      results[0..2]
    end

    def self.new_oauth2_token
      scope = 'https://www.googleapis.com/auth/analytics.readonly'
      client = Google::APIClient.new(
        application_name:    'MAS-Blog',
        application_version: '1.0.0'
      )
      key = Google::APIClient::PKCS12.load_key(ENV['GA_PRIVATE_KEY_FILENAME'], 'notasecret')
      service_account = Google::APIClient::JWTAsserter.new(ENV['GA_API_EMAIL_ADDRESS'], scope, key)
      client.authorization = service_account.authorize
      OAuth2::AccessToken.new(oauth_client, client.authorization.access_token, expires_in: 1.hour)
    end

    def self.oauth_client
      OAuth2::Client.new('', '',
                         authorize_url: 'https://accounts.google.com/o/oauth2/auth',
                         token_url: 'https://accounts.google.com/o/oauth2/token')
    end
  end
end
