require 'digest/sha1'

class User < ActiveRecord::Base
  belongs_to :profile
  belongs_to :text_filter
  has_many :notifications, :foreign_key => 'notify_user_id'
  has_many :notify_contents, :through => :notifications,
    :source => 'notify_content',
    :uniq => true

  has_many :articles, :order => 'created_at DESC' do
    def published
      find_published(:all, :order => 'created_at DESC')
    end
  end
  has_many :published_articles,
    :class_name => 'Article',
    :conditions => { :published => true },
    :order      => "published_at DESC"

  # echo "typo" | sha1sum -
  @@salt = '20ac4d290c2293702c64b3b287ae5ea79b26a5c1'
  cattr_accessor :salt

  def self.authenticate(login, pass)
    find(:first,
         :conditions => ["login = ? AND password = ? AND state = ?", login, sha1(pass), 'active'])
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
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def permalink_url(anchor=nil, only_path=true)
    blog = Blog.default # remove me...

    blog.url_for(
      :controller => 'users',
      :action => 'show',
      :id => permalink
    )
  end
  
  def self.authenticate?(login, pass)
    user = self.authenticate(login, pass)
    return false if user.nil?
    return true if user.login == login

    false
  end

  def self.find_by_permalink(permalink)
    returning(self.find_by_login(permalink)) do |user|
      raise ActiveRecord::RecordNotFound unless user
    end
  end

  # The current project_modules
  def project_modules
    profile.modules.collect { |m| AccessControl.project_module(profile.label, m) }.uniq.compact rescue []
  end
  
  # Generate Methods takes from AccessControl rules
  # Example:
  #
  #   def publisher?
  #     profile.label == :publisher
  #   end
  AccessControl.roles.each { |r| define_method("#{r.to_s.downcase.to_sym}?") { profile.label.to_s.downcase.to_sym == r.to_s.downcase.to_sym } }

  # Let's be lazy, no need to fetch the counters, rails will handle it.
  def self.find_all_with_article_counters(ignored_arg)
    find(:all)
  end

  def self.to_prefix
    'author'
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
  def self.sha1(pass)
    Digest::SHA1.hexdigest("#{salt}--#{pass}--")
  end

  before_create :crypt_password

  # Before saving the record to database we will crypt the password
  # using SHA1.
  # We never store the actual password in the DB.
  # But before the encryption, we send an email to user for he can remind his
  # password
  def crypt_password
    send_create_notification
    write_attribute "password", self.class.sha1(password(true))
    @password = nil
  end

  before_update :crypt_unless_empty

  # If the record is updated we will check if the password is empty.
  # If its empty we assume that the user didn't want to change his
  # password and just reset it to the old value.
  def crypt_unless_empty
    if password(true).empty?
      user = self.class.find(self.id)
      self.password = user.password
    else
      write_attribute "password", self.class.sha1(password(true))
      @password = nil
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
  validates_length_of :password, :within => 5..40, :on => :update
  validates_presence_of :login
  validates_presence_of :email

  validates_confirmation_of :password, :if => Proc.new { |u| u.password.size > 0}, :on => :update
  validates_length_of :login, :within => 3..40


  private

  # Send a mail of creation user to the user create
  def send_create_notification
    begin
      email_notification = NotificationMailer.create_notif_user(self)
      EmailNotify.send_message(self,email_notification)
    rescue => err
      logger.error "Unable to send notification of create user email: #{err.inspect}"
    end
  end
end
