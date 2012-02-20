require 'digest/sha1'

# Typo user.
class User < ActiveRecord::Base
  include ConfigManager

  belongs_to :profile
  belongs_to :text_filter

  delegate :name, :to => :text_filter, :prefix => true
  delegate :label, :to => :profile, :prefix => true

  has_many :notifications, :foreign_key => 'notify_user_id'
  has_many :notify_contents, :through => :notifications,
    :source => 'notify_content',
    :uniq => true

  has_many :articles, :order => 'created_at DESC'

  serialize :settings, Hash

  # Settings
  setting :notify_watch_my_articles,   :boolean, true
  setting :editor,                     :string, 'visual'
  setting :firstname,                  :string, ''
  setting :lastname,                   :string, ''
  setting :nickname,                   :string, ''
  setting :description,                :string, ''
  setting :url,                        :string, ''
  setting :msn,                        :string, ''
  setting :aim,                        :string, ''
  setting :yahoo,                      :string, ''
  setting :twitter,                    :string, ''
  setting :jabber,                     :string, ''
  setting :show_url,                   :boolean, false
  setting :show_msn,                   :boolean, false
  setting :show_aim,                   :boolean, false
  setting :show_yahoo,                 :boolean, false
  setting :show_twitter,               :boolean, false
  setting :show_jabber,                :boolean, false
  setting :admin_theme,                :string,  'blue'

  # echo "typo" | sha1sum -
  class_attribute :salt

  def self.salt
    '20ac4d290c2293702c64b3b287ae5ea79b26a5c1'
  end

  attr_accessor :last_venue

  def initialize(*args)
    super
    self.settings ||= {}
  end


  def self.authenticate(login, pass)
    find(:first,
         :conditions => ["login = ? AND password = ? AND state = ?", login, password_hash(pass), 'active'])
  end

  def update_connection_time
    self.last_venue = last_connection
    self.last_connection = Time.now
    self.save
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = Digest::SHA1.hexdigest("#{email}--#{remember_token_expires_at}")
    save(:validate => false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(:validate => false)
  end

  def permalink_url(anchor=nil, only_path=false)
    blog = Blog.default # remove me...

    blog.url_for(
      :controller => 'authors',
      :action => 'show',
      :id => login,
      :only_path => only_path
    )
  end

  def self.authenticate?(login, pass)
    user = self.authenticate(login, pass)
    return false if user.nil?
    return true if user.login == login

    false
  end

  def self.find_by_permalink(permalink)
    self.find_by_login(permalink).tap do |user|
      raise ActiveRecord::RecordNotFound unless user
    end
  end

  def project_modules
    profile.project_modules
  end

  # Generate Methods takes from AccessControl rules
  # Example:
  #
  #   def publisher?
  #     profile.label == :publisher
  #   end
  AccessControl.roles.each do |role|
    define_method "#{role.to_s.downcase}?" do
      profile.label.to_s.downcase == role.to_s.downcase
    end
  end

  def self.to_prefix
    'author'
  end

  def simple_editor?
    editor == 'simple'
  end

  def password=(newpass)
    @password = newpass
  end

  def password(cleartext = nil)
    if cleartext
      @password.to_s
    else
      @password || read_attribute("password")
    end
  end

  def article_counter
    articles.size
  end

  def display_name
    name
  end

  def permalink
    login
  end

  def to_param
    permalink
  end

  def admin?
    profile.label == Profile::ADMIN
  end

  protected

  # Apply SHA1 encryption to the supplied password.
  # We will additionally surround the password with a salt
  # for additional security.
  def self.password_hash(pass)
    Digest::SHA1.hexdigest("#{salt}--#{pass}--")
  end

  def password_hash(pass)
    self.class.password_hash(pass)
  end

  before_create :crypt_password

  # Before saving the record to database we will crypt the password
  # using SHA1.
  # We never store the actual password in the DB.
  # But before the encryption, we send an email to user for he can remind his
  # password
  def crypt_password
    send_create_notification
    write_attribute "password", password_hash(password(true))
    @password = nil
  end

  before_update :crypt_unless_empty

  # If the record is updated we will check if the password is empty.
  # If its empty we assume that the user didn't want to change his
  # password and just reset it to the old value.
  def crypt_unless_empty
    if password(true).empty?
      user = self.class.find(self.id)
      write_attribute "password", user.password
    else
      crypt_password
    end
  end

  before_validation :set_default_profile

  def set_default_profile
    if User.count.zero?
      self.profile ||= Profile.find_by_label('admin')
    else
      self.profile ||= Profile.find_by_label('contributor')
    end
  end

  validates_uniqueness_of :login, :on => :create
  validates_uniqueness_of :email, :on => :create
  validates_length_of :password, :within => 5..40, :if => Proc.new { |user|
    user.read_attribute('password').nil? or user.password.to_s.length > 0
  }

  validates_presence_of :login
  validates_presence_of :email

  validates_confirmation_of :password
  validates_length_of :login, :within => 3..40


  private

  # Send a mail of creation user to the user create
  def send_create_notification
    begin
      email_notification = NotificationMailer.notif_user(self)
      EmailNotify.send_message(self, email_notification)
    rescue => err
      logger.error "Unable to send notification of create user email: #{err.inspect}"
    end
  end
end
