require 'set'
require 'uri'

class Content < ActiveRecord::Base
  include Stateful

  include ContentBase

  # TODO: Move these calls to ContentBase
  after_save :invalidates_cache?
  after_destroy lambda { |c|  c.invalidates_cache?(true) }

  belongs_to :text_filter

  has_many :redirections
  has_many :redirects, :through => :redirections, :dependent => :destroy

  has_many :triggers, :as => :pending_item, :dependent => :delete_all

  scope :user_id, lambda { |user_id| where('user_id = ?', user_id) }
  scope :published, lambda { where('published = ?', true) }
  scope :not_published, lambda { where('published = ?', false) }
  scope :draft, lambda { where('state = ?', 'draft') }
  scope :no_draft, lambda { where('state <> ?', 'draft').order('published_at DESC') }
  scope :searchstring, lambda { |search_string|
    tokens = search_string.split(' ').collect {|c| "%#{c.downcase}%"}
    where('state = ? AND ' + (['(LOWER(body) LIKE ? OR LOWER(extended) LIKE ? OR LOWER(title) LIKE ?)']*tokens.size).join(' AND '),
                     "published", *tokens.collect{ |token| [token] * 3 }.flatten)
  }
  scope :already_published, lambda { where('published = ? AND published_at < ?', true, Time.now).order(default_order) }

  # Use only for self.function_search_all_posts method
  scope :published_at_like, lambda { |date_at| where(:published_at => (
      if date_at =~ /\d{4}-\d{2}-\d{2}/
        DateTime.strptime(date_at, '%Y-%m-%d').beginning_of_day..DateTime.strptime(date_at, '%Y-%m-%d').end_of_day
    elsif date_at =~ /\d{4}-\d{2}/
      DateTime.strptime(date_at, '%Y-%m').beginning_of_month..DateTime.strptime(date_at, '%Y-%m').end_of_month
    elsif date_at =~ /\d{4}/
      DateTime.strptime(date_at, '%Y').beginning_of_year..DateTime.strptime(date_at, '%Y').end_of_year
    else
      date_at
    end)
  )}

  serialize :whiteboard

  def shorten_url
    return unless self.published

    r = Redirect.new
    r.from_path = r.shorten
    r.to_path = self.permalink_url

    # This because updating self.redirects.first raises ActiveRecord::ReadOnlyRecord
    unless (red = self.redirects.first).nil?
      return if red.to_path == self.permalink_url
      r.from_path = red.from_path
      red.destroy
      self.redirects.clear # not sure we need this one
    end

    self.redirects << r
  end

  def self.find_already_published(limit)
    where('published_at < ?', Time.now).limit(1000).order('created_at DESC')
  end

  def self.function_search_all_posts(search_hash)
    list_function = []
    search_hash ||= {}

    if search_hash[:searchstring]
      list_function << 'searchstring(search_hash[:searchstring])' unless search_hash[:searchstring].to_s.empty?
    end

    if search_hash[:published_at] and %r{(\d\d\d\d)-(\d\d)} =~ search_hash[:published_at]
      list_function << 'published_at_like(search_hash[:published_at])'
    end

    if search_hash[:user_id] && search_hash[:user_id].to_i > 0
      list_function << 'user_id(search_hash[:user_id])'
    end

    if search_hash[:published]
      list_function << 'published' if search_hash[:published].to_s == '1'
      list_function << 'not_published' if search_hash[:published].to_s == '0'
    end

    list_function
  end

  def whiteboard
    self[:whiteboard] ||= Hash.new
  end

  def withdraw!
    self.withdraw
    self.save!
  end

  def published_at
    self[:published_at] || self[:created_at]
  end

  def get_rss_description
    return "" unless blog.rss_description
    return "" unless respond_to?(:user) && self.user && self.user.name

    rss_desc = blog.rss_description_text
    rss_desc.gsub!('%author%', self.user.name)
    rss_desc.gsub!('%blog_url%', blog.base_url)
    rss_desc.gsub!('%blog_name%', blog.blog_name)
    rss_desc.gsub!('%permalink_url%', self.permalink_url)
    return rss_desc
  end

  # TODO: Perhaps permalink_url should produce valid URI's instead of IRI's
  def normalized_permalink_url
    @normalized_permalink_url ||= Addressable::URI.parse(permalink_url).normalize
  end

  def short_url
    # Double check because of crappy data in my own old database
    return unless self.published and self.redirects.size > 0
    blog.url_for(redirects.last.from_path, :only_path => false)
  end

end

class Object
  def to_text_filter
    TextFilter.find_by_name(self.to_s) || TextFilter.find_by_name('none')
  end
end

class ContentTextHelpers
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TextHelper
  extend ActionView::Helpers::SanitizeHelper::ClassMethods
end

