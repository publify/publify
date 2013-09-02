class Note < Content
  require 'twitter'
  require 'json'
  require 'uri'
  include PublifyGuid
  include ConfigManager

  serialize :settings, Hash

  setting :twitter_id,                          :string,    ""
  setting :in_reply_to_status_id,               :string,    ""
  setting :in_reply_to_protected,               :boolean,   false
  setting :in_reply_to_message,                 :string,    ""
  
  belongs_to :user
  validates_presence_of :body
  validates_uniqueness_of :permalink, :guid
  attr_accessor :push_to_twitter, :twitter_message
  
  after_create :set_permalink, :shorten_url
  before_create :create_guid

  default_scope order("published_at DESC")  

  TWITTER_FTP_URL_LEGTH = 19
  TWITTER_HTTP_URL_LENGTH = 20
  TWITTER_HTTPS_URL_LENGTH = 21

  def set_permalink
    self.permalink = "#{self.id}-#{self.body.to_permalink[0..79]}" if self.permalink.nil? or self.permalink.empty?
    self.save
  end

  def set_author(user)
    self.author = user.login
    self.user = user
  end

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

  def send_to_twitter
    return false unless self.push_to_twitter # Then, what are we doing here?!
    return false unless Blog.default.has_twitter_configured?
    return false unless self.user.has_twitter_configured?
    
    twitter = Twitter::Client.new(
      :consumer_key => Blog.default.twitter_consumer_key,
      :consumer_secret => Blog.default.twitter_consumer_secret,
      :oauth_token => self.user.twitter_oauth_token,
      :oauth_token_secret => self.user.twitter_oauth_token_secret
    )
    
    build_twitter_message
    
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
      return true
    rescue
      return false
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

  private
  def calculate_real_length
    message = self.twitter_message
    
    uris = URI.extract(message, ['http', 'https', 'ftp'])
    uris.each do |uri|
      case uri.split(":")[0]
      when "http"
        payload = "-" * TWITTER_HTTP_URL_LENGTH
      when "https"
        payload = "-" * TWITTER_HTTPS_URL_LENGTH
      when "ftp"
        payload = "-" * TWITTER_FTP_URL_LEGTH
      end
      
      message = message.gsub(uri, payload)
    end

    return message.length
  end

  def build_short_link(length)
    if length > 115
      return "... #{self.redirects.first.to_url}"
    else
      path = self.redirects.first.from_path
      blog = Blog.default
      prefix = (blog.custom_url_shortener) ? blog.custom_url_shortener : blog.base_url
      prefix.sub!(/^https?\:\/\//, '')
      return " (#{prefix} #{path})"
    end
  end
  
  def build_twitter_message
    self.twitter_message = self.body.strip_html
    
    length = calculate_real_length
    
    if length > 114
      self.twitter_message = "#{self.twitter_message[0..113]}#{build_short_link(length)}"
    else
      self.twitter_message = "#{self.twitter_message}#{build_short_link(length)}"
    end
  end
end
