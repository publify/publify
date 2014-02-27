class Note < Content
  require 'twitter'
  require 'json'
  require 'uri'
  include PublifyGuid
  include ConfigManager

  serialize :settings, Hash

  setting :twitter_id, :string, ""
  setting :in_reply_to_status_id, :string, ""
  setting :in_reply_to_protected, :boolean, false
  setting :in_reply_to_message, :string, ""

  validates_presence_of :body
  validates_uniqueness_of :permalink, :guid

  after_create :set_permalink, :shorten_url
  before_create :create_guid

  default_scope order("published_at DESC")

  TWITTER_FTP_URL_LENGTH = 19
  TWITTER_HTTP_URL_LENGTH = 20
  TWITTER_HTTPS_URL_LENGTH = 21
  TWITTER_LINK_LENGTH = 22

  def set_permalink
    self.permalink = "#{self.id}-#{self.body.to_permalink[0..79]}" if self.permalink.nil? or self.permalink.empty?
    self.save
  end

  def categories;[];end
  def tags;[];end

  def html_preprocess(field, html)
    PublifyApp::Textfilter::Twitterfilter.filtertext(nil,nil,html,nil).nofollowify
  end

  def initialize(*args)
    super
    # Yes, this is weird - PDC
    begin
      self.settings ||= {}
    rescue Exception => e
      self.settings = {}
    end
  end

  def truncate(message, length)
    if message[length + 1] == ' '
      message[0..length]
    else
      message[0..(message[0..length].rindex(' ') - 1)]
    end
  end

  def twitter_message
    base_message = self.body.strip_html
    if too_long?("#{base_message} (#{short_link})")
      max_length = 140 - "... (#{redirects.first.to_url})".length - 1
      "#{truncate(base_message, max_length)}... (#{self.redirects.first.to_url})"
    else
      "#{base_message} (#{short_link})"
    end
  end

  def twitter_url
    File.join('https://twitter.com', user.twitter, 'status', twitter_id)
  end

  def send_to_twitter
    return false unless Blog.default.has_twitter_configured?
    return false unless self.user.has_twitter_configured?

    twitter = Twitter::REST::Client.new do |config|
      config.consumer_key = Blog.default.twitter_consumer_key
      config.consumer_secret = Blog.default.twitter_consumer_secret
      config.oauth_token = self.user.twitter_oauth_token
      config.oauth_token_secret = self.user.twitter_oauth_token_secret
    end

    begin
      options = {}
      if self.in_reply_to_status_id and self.in_reply_to_status_id != ""
        options = {:in_reply_to_status_id => self.in_reply_to_status_id}
        self.in_reply_to_message = twitter.status(self.in_reply_to_status_id).to_json
      end
      tweet = twitter.update(self.twitter_message, options)
      self.twitter_id = tweet.attrs[:id_str]
      self.save
      self.user.update_twitter_profile_image(tweet.attrs[:user][:profile_image_url])
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

  def permalink_url(anchor=nil, only_path=false)
    blog.url_for(
      :controller => '/notes',
      :action => 'show',
      :permalink => permalink,
      :anchor => anchor,
      :only_path => only_path
    )
  end

  def short_link
    path = self.redirects.first.from_path
    prefix.sub!(/^https?\:\/\//, '')
    "#{prefix} #{path}"
  end

  def prefix
    blog.custom_url_shortener.present? ? blog.custom_url_shortener : blog.base_url
  end

  private

  def too_long?(message)
    uris = URI.extract(message, ['http', 'https', 'ftp'])
    uris << prefix
    uris.each do |uri|
      case uri.split(":")[0]
      when "https"
        payload = "-" * TWITTER_HTTPS_URL_LENGTH
      when "ftp"
        payload = "-" * TWITTER_FTP_URL_LENGTH
      else
        payload = "-" * TWITTER_HTTP_URL_LENGTH
      end
      message = message.gsub(uri, payload)
    end
    message.length > 140
  end
end
