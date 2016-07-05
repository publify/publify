require 'set'
require 'uri'

class Content < ActiveRecord::Base
  include Stateful

  include ContentBase

  # TODO: Move these calls to ContentBase
  after_save :invalidates_cache?
  after_destroy ->(c) { c.invalidates_cache?(true) }

  belongs_to :text_filter
  belongs_to :user
  belongs_to :blog

  validates :blog, presence: true

  has_one :redirect, dependent: :destroy

  has_many :triggers, as: :pending_item, dependent: :delete_all

  scope :user_id, ->(user_id) { where('user_id = ?', user_id) }
  scope :published, -> { where(published: true, published_at: Time.at(0)..Time.now).order('published_at DESC') }
  scope :published_at, ->(time_params) { published.where(published_at: PublifyTime.delta(*time_params)).order('published_at DESC') }
  scope :not_published, -> { where('published = ?', false) }
  scope :draft, -> { where('state = ?', 'draft') }
  scope :no_draft, -> { where('state <> ?', 'draft').order('published_at DESC') }
  scope :searchstring, lambda { |search_string|
    tokens = search_string.split(' ').map { |c| "%#{c.downcase}%" }
    where('state = ? AND ' + (['(LOWER(body) LIKE ? OR LOWER(extended) LIKE ? OR LOWER(title) LIKE ?)'] * tokens.size).join(' AND '),
          'published', *tokens.map { |token| [token] * 3 }.flatten)
  }
  scope :already_published, -> { where('published = ? AND published_at < ?', true, Time.now).order(default_order) }

  scope :published_at_like, ->(date_at) { where(published_at: PublifyTime.delta_like(date_at)) }

  serialize :whiteboard

  def author=(user)
    if user.respond_to?(:login)
      self[:author] = user.login
      self.user = user
    elsif user.is_a?(String)
      self[:author] = user
    end
  end

  # Set the text filter for this object.
  # NOTE: Due to how Rails injects association methods, this cannot be put in ContentBase
  # TODO: Allowing assignment of a string here is not very clean.
  def text_filter=(filter)
    filter_object = case filter
                    when TextFilter
                      filter
                    else
                      TextFilter.find_or_default(filter)
                    end
    self.text_filter_id = if filter_object
                            filter_object.id
                          else
                            filter.to_i
                          end
  end

  def shorten_url
    return unless published

    if redirect.present?
      return if redirect.to_path == permalink_url
      redirect.to_path = permalink_url
      redirect.save
    else
      r = Redirect.new(blog: blog)
      r.from_path = r.shorten
      r.to_path = permalink_url
      self.redirect = r
    end
  end

  def self.find_already_published(_limit)
    where('published_at < ?', Time.now).limit(1000).order('created_at DESC')
  end

  def self.search_with(params)
    params ||= {}
    scoped = unscoped
    if params[:searchstring].present?
      scoped = scoped.searchstring(params[:searchstring])
    end

    if params[:published_at].present? && /(\d\d\d\d)-(\d\d)/ =~ params[:published_at]
      scoped = scoped.published_at_like(params[:published_at])
    end

    if params[:user_id].present? && params[:user_id].to_i > 0
      scoped = scoped.user_id(params[:user_id])
    end

    if params[:published].present?
      scoped = scoped.published if params[:published].to_s == '1'
      scoped = scoped.not_published if params[:published].to_s == '0'
    end

    scoped
  end

  def whiteboard
    self[:whiteboard] ||= {}
  end

  def withdraw!
    withdraw
    save!
  end

  def link_to_author?
    !user.email.blank? && blog.link_to_author
  end

  def get_rss_description
    return '' unless blog.rss_description
    return '' unless respond_to?(:user) && user && user.name

    rss_desc = blog.rss_description_text
    rss_desc.gsub!('%author%', user.name)
    rss_desc.gsub!('%blog_url%', blog.base_url)
    rss_desc.gsub!('%blog_name%', blog.blog_name)
    rss_desc.gsub!('%permalink_url%', permalink_url)
    rss_desc
  end

  # TODO: Perhaps permalink_url should produce valid URI's instead of IRI's
  def normalized_permalink_url
    @normalized_permalink_url ||= Addressable::URI.parse(permalink_url).normalize
  end

  def short_url
    # Double check because of crappy data in my own old database
    return unless published && redirect.present?
    redirect.from_url
  end
end

class ContentTextHelpers
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TextHelper
  extend ActionView::Helpers::SanitizeHelper::ClassMethods
end
