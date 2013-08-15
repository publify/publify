class Status < Content
  require 'twitter'
  require 'json'
  require 'uri'
  include PublifyGuid
  include ConfigManager

  serialize :settings, Hash

  setting :twitter_id, :string, ''
  
  belongs_to :user
  validates_presence_of :body
  validates_uniqueness_of :permalink
  attr_accessor :push_to_twitter
  
  after_create :set_permalink, :shorten_url

  default_scope order("published_at DESC")  

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

  def send_to_twitter(user)
    blog = Blog.default
    return if blog.twitter_consumer_key.nil? or blog.twitter_consumer_secret.nil?
    return unless user.twitter_configured?
    twitter = Twitter::Client.new(
      :consumer_key => blog.twitter_consumer_key,
      :consumer_secret => blog.twitter_consumer_secret,
      :oauth_token => user.twitter_oauth_token,
      :oauth_token_secret => user.twitter_oauth_token_secret
    )
    
    message = self.body.strip_html

    length = calculate_real_length(message)
    short_permalink = build_short_link(length)
    
    if length > 114
      message = "#{message[0..114]}#{short_permalink}"
    else
      message = "#{message}#{short_permalink}"
    end

    puts message

    begin
      tweet = twitter.update(message)
      self.twitter_id = tweet.attrs[:id_str]
      self.save
    
      user.update_twitter_profile_image(tweet.attrs[:user][:profile_image_url])
    rescue
      flash[:error] = "Oooops something wrong happened"
    end
  end

  content_fields :body

  def access_by?(user)
    user.admin? || user_id == user.id
  end

  def permalink_url(anchor=nil, only_path=false)
    blog.url_for(
      :controller => '/statuses',
      :action => 'show',
      :permalink => permalink,
      :anchor => anchor,
      :only_path => only_path
    )
  end

  private
  def calculate_real_length(message)    
    uris = URI.extract(message, ['http', 'https', 'ftp'])
    uris.each do |uri|
      message = message.gsub(uri, "---------------------")
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
end
