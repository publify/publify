# frozen_string_literal: true

require "digest/sha1"

# Publify user.
# TODO: Should belong to a blog
class User < ApplicationRecord
  ADMIN = "admin"
  PUBLISHER = "publisher"
  CONTRIBUTOR = "contributor"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :zxcvbnable
  include ConfigManager
  include StringLengthLimit

  before_validation :set_default_profile

  validates :login, uniqueness: true
  validates :email, :login, presence: true
  validates :login, length: { in: 3..40 }
  validates_default_string_length :email, :text_filter_name
  validates :name, length: { maximum: 2048 }

  belongs_to :resource, optional: true
  has_many :notifications, foreign_key: "notify_user_id"
  has_many :notify_contents, -> { uniq }, through: :notifications,
                                          source: "notify_content"

  has_many :articles

  serialize :settings, Hash

  STATUS = %w(active inactive).freeze

  attr_accessor :filename

  # Settings
  setting :notify_watch_my_articles, :boolean, true
  setting :firstname, :string, ""
  setting :lastname, :string, ""
  setting :nickname, :string, ""
  setting :description, :string, ""
  setting :url, :string, ""
  setting :msn, :string, ""
  setting :aim, :string, ""
  setting :yahoo, :string, ""
  setting :twitter, :string, ""
  setting :jabber, :string, ""
  setting :admin_theme, :string, "blue"
  setting :twitter_account, :string, ""
  setting :twitter_oauth_token, :string, ""
  setting :twitter_oauth_token_secret, :string, ""
  setting :twitter_profile_image, :string, ""

  # echo "publify" | sha1sum -
  class_attribute :salt

  def self.salt
    "20ac4d290c2293702c64b3b287ae5ea79b26a5c1"
  end

  def first_and_last_name
    return "" unless firstname.present? && lastname.present?

    "#{firstname} #{lastname}"
  end

  def display_names
    [:login, :nickname, :firstname, :lastname, :first_and_last_name].
      map { |f| send(f) }.delete_if(&:empty?)
  end

  # Authenticate users with old password hashes
  alias devise_valid_password? valid_password?

  def valid_password?(password)
    devise_valid_password?(password)
  rescue BCrypt::Errors::InvalidHash
    digest = Digest::SHA1.hexdigest("#{self.class.salt}--#{password}--")
    if digest == encrypted_password
      # Update old SHA1 password with new Devise ByCrypt password
      self.encrypted_password = password_digest(password)
      save
      true
    else
      # If not BCrypt password and not old SHA1 password deny access
      false
    end
  end

  def active_for_authentication?
    super && state == "active"
  end

  def text_filter
    TextFilter.make_filter(text_filter_name)
  end

  def self.to_prefix
    "author"
  end

  def article_counter
    articles.size
  end

  def display_name
    if nickname.present?
      nickname
    elsif name.present?
      name
    else
      login
    end
  end

  def permalink
    login
  end

  def admin?
    profile == User::ADMIN
  end

  def update_twitter_profile_image(img)
    return if twitter_profile_image == img

    self.twitter_profile_image = img
    save
  end

  def has_twitter_configured?
    twitter_oauth_token.present? && twitter_oauth_token_secret.present?
  end

  private

  def set_default_profile
    self.profile ||= User.count.zero? ? "admin" : "contributor"
  end
end
