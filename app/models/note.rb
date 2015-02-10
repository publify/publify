class Note < Content
  require 'twitter'
  require 'json'
  require 'uri'
  include PublifyGuid
  include ConfigManager

  serialize :settings, Hash

  setting :twitter_id, :string, ''
  setting :in_reply_to_status_id, :string, ''
  setting :in_reply_to_protected, :boolean, false
  setting :in_reply_to_message, :string, ''

  validates :body, presence: true
  validates :permalink, :guid, uniqueness: true

  after_create :set_permalink, :shorten_url
  before_create :create_guid

  default_scope { order('published_at DESC') }

  TWITTER_FTP_URL_LENGTH = 19
  TWITTER_HTTP_URL_LENGTH = 20
  TWITTER_HTTPS_URL_LENGTH = 21
  TWITTER_LINK_LENGTH = 22

  def set_permalink
    self.permalink = "#{id}-#{body.to_permalink[0..79]}" if permalink.nil? || permalink.empty?
    save
  end

  def categories
    []
  end

  def tags
    []
  end

  def html_preprocess(_field, html)
    PublifyApp::Textfilter::Twitterfilter.filtertext(nil, nil, html, nil).nofollowify
  end

  def truncate(message, length)
    if message[length + 1] == ' '
      message[0..length]
    else
      message[0..(message[0..length].rindex(' ') - 1)]
    end
  end

  def twitter_message
    base_message = body.strip_html
    if too_long?("#{base_message} (#{short_link})")
      max_length = 140 - "... (#{redirects.first.to_url})".length - 1
      "#{truncate(base_message, max_length)}... (#{redirects.first.to_url})"
    else
      "#{base_message} (#{short_link})"
    end
  end

  def twitter_url
    File.join('https://twitter.com', user.twitter, 'status', twitter_id)
  end

  def send_to_twitter
    return false unless Blog.default.has_twitter_configured?
    return false unless user.has_twitter_configured?

    twitter = Twitter::REST::Client.new do |config|
      config.consumer_key = Blog.default.twitter_consumer_key
      config.consumer_secret = Blog.default.twitter_consumer_secret
      config.access_token = user.twitter_oauth_token
      config.access_token_secret = user.twitter_oauth_token_secret
    end

    begin
      options = {}
      if in_reply_to_status_id && in_reply_to_status_id != ''
        options = { in_reply_to_status_id: in_reply_to_status_id }
        self.in_reply_to_message = twitter.status(in_reply_to_status_id).to_json
      end
      tweet = twitter.update(twitter_message, options)
      self.twitter_id = tweet.attrs[:id_str]
      save
      user.update_twitter_profile_image(tweet.attrs[:user][:profile_image_url])
      true
    rescue StandardError => e
      Rails.logger.error("Error while sending to twitter: #{e}")
      errors.add(:message, e)
      false
    end
  end

  content_fields :body

  def password_protected?
    false
  end

  def access_by?(user)
    user.admin? || user_id == user.id
  end

  def permalink_url(anchor = nil, only_path = false)
    blog.url_for(
      controller: '/notes',
      action: 'show',
      permalink: permalink,
      anchor: anchor,
      only_path: only_path
    )
  end

  def short_link
    path = redirects.first.from_path
    prefix.sub!(/^https?\:\/\//, '')
    "#{prefix} #{path}"
  end

  def prefix
    blog.custom_url_shortener.present? ? blog.custom_url_shortener : blog.base_url
  end

  private

  def too_long?(message)
    uris = URI.extract(message, %w(http https ftp))
    uris << prefix
    uris.each do |uri|
      case uri.split(':')[0]
      when 'https'
        payload = '-' * TWITTER_HTTPS_URL_LENGTH
      when 'ftp'
        payload = '-' * TWITTER_FTP_URL_LENGTH
      else
        payload = '-' * TWITTER_HTTP_URL_LENGTH
      end
      message = message.gsub(uri, payload)
    end
    message.length > 140
  end
end
