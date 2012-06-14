require 'set'
require 'uri'

class Content < ActiveRecord::Base
  belongs_to :text_filter

  has_many :notifications, :foreign_key => 'content_id'
  has_many :notify_users, :through => :notifications,
    :source => 'notify_user',
    :uniq => true
  has_many :redirections
  has_many :redirects, :through => :redirections, :dependent => :destroy

  def notify_users=(collection)
    return notify_users.clear if collection.empty?
    self.class.transaction do
      self.notifications.clear
      collection.uniq.each do |u|
        self.notifications.build(:notify_user => u)
      end
      notify_users.target = collection
    end
  end

  has_many :triggers, :as => :pending_item, :dependent => :delete_all

  scope :published_at_like, lambda {|date_at| {:conditions => {
    :published_at => (
      if date_at =~ /\d{4}-\d{2}-\d{2}/
        DateTime.strptime(date_at, '%Y-%m-%d').beginning_of_day..DateTime.strptime(date_at, '%Y-%m-%d').end_of_day
      elsif date_at =~ /\d{4}-\d{2}/
        DateTime.strptime(date_at, '%Y-%m').beginning_of_month..DateTime.strptime(date_at, '%Y-%m').end_of_month
      elsif date_at =~ /\d{4}/
        DateTime.strptime(date_at, '%Y').beginning_of_year..DateTime.strptime(date_at, '%Y').end_of_year
      else
        date_at
      end
    )}
  }
  }
  scope :user_id, lambda {|user_id| {:conditions => ['user_id = ?', user_id]}}
  scope :published, {:conditions => ['published = ?', true]}
  scope :not_published, {:conditions => ['published = ?', false]}
  scope :draft, {:conditions => ['state = ?', 'draft']}
  scope :no_draft, {:conditions => ['state <> ?', 'draft'], :order => 'published_at DESC'}
  scope :searchstring, lambda {|search_string|
    tokens = search_string.split(' ').collect {|c| "%#{c.downcase}%"}
    {:conditions => ['state = ? AND ' + (['(LOWER(body) LIKE ? OR LOWER(extended) LIKE ? OR LOWER(title) LIKE ?)']*tokens.size).join(' AND '),
                        "published", *tokens.collect{ |token| [token] * 3 }.flatten]}
  }
  scope :already_published, lambda { {:conditions => ['published = ? AND published_at < ?', true, Time.now],
    :order => default_order,
    }}

  serialize :whiteboard

  attr_accessor :just_changed_published_status
  alias_method :just_changed_published_status?, :just_changed_published_status

  after_save :invalidates_cache?
  after_destroy lambda { |c|  c.invalidates_cache?(true) }

  include Stateful

  def invalidates_cache?(on_destruction = false)
    @invalidates_cache ||= if on_destruction
      just_changed_published_status? || published?
    else
      (changed? && published?) || just_changed_published_status?
    end
  end
  
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

  class << self
    def content_fields *attribs
      class_eval "def content_fields; #{attribs.inspect}; end"
    end

    def find_published(what = :all, options = {})
      with_scope(:find => {:order => default_order, :conditions => {:published => true}}) do
        find what, options
      end
    end

    def default_order
      'published_at DESC'
    end

    def find_already_published(what = :all, at = nil, options = { })
      if what.respond_to?(:has_key?)
        what, options = :all, what
      elsif at.respond_to?(:has_key?)
        options, at = at, nil
      end
      at ||= options.delete(:at) || Time.now
      with_scope(:find => { :conditions => ['published_at < ?', at]}) do
        find_published(what, options)
      end
    end

    def find_by_published_at(column_name = :published_at)
      from_where = "FROM #{self.table_name} WHERE #{column_name} is not NULL AND type='#{self.name}'"

      # Implement adapter-specific groupings below, or allow us to fall through to the generic ruby-side grouping

      if defined?(ActiveRecord::ConnectionAdapters::MysqlAdapter) && self.connection.is_a?(ActiveRecord::ConnectionAdapters::MysqlAdapter)
        # MySQL uses date_format
        find_by_sql("SELECT date_format(#{column_name}, '%Y-%m') AS publication #{from_where} GROUP BY publication ORDER BY publication DESC")

      elsif defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter) && self.connection.is_a?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
        # PostgreSQL uses to_char
        find_by_sql("SELECT to_char(#{column_name}, 'YYYY-MM') AS publication #{from_where} GROUP BY publication ORDER BY publication DESC")

      else
        # If we don't have an adapter-safe conversion from date -> YYYY-MM,
        # we'll do the GROUP BY server-side. There won't be very many objects
        # in this array anyway.
        date_map = {}
        dates = find_by_sql("SELECT #{column_name} AS publication #{from_where}")

        dates.map! do |d|
          d.publication = Time.parse(d.publication).strftime('%Y-%m')
          d.freeze
          if !date_map.has_key?(d.publication)
            date_map[d.publication] = true
            d
          end
        end
        dates.reject!{|d| d.blank? || d.publication.blank?}
        dates.sort!{|a,b| b.publication <=> a.publication}

        dates
      end
    end

    def function_search_no_draft(search_hash)
      list_function = []
      if search_hash.nil?
        search_hash = {}
      end

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
  end

  def html_map field
    content_fields.include? field
  end

  # Return HTML for some part of this object.
  def html(field = :all)
    if field == :all
      generate_html(:all, content_fields.map{|f| self[f].to_s}.join("\n\n"))
    elsif html_map(field)
      generate_html(field)
    else
      raise "Unknown field: #{field.inspect} in content.html"
    end
  end

  # Generate HTML for a specific field using the text_filter in use for this
  # object.
  def generate_html(field, text = nil)
    text ||= self[field].to_s
    html = text_filter.filter_text_for_content(blog, text, self) || text
    html_postprocess(field,html).to_s
  end

  # Post-process the HTML.  This is a noop by default, but Comment overrides it
  # to enforce HTML sanity.
  def html_postprocess(field,html)
    html
  end

  def whiteboard
    self[:whiteboard] ||= Hash.new
  end

  # The default text filter.  Generally, this is the filter specified by blog.text_filter,
  # but comments may use a different default.
  def default_text_filter
    blog.text_filter_object
  end

  # Grab the text filter for this object.  It's either the filter specified by
  # self.text_filter_id, or the default specified in the default blog object.
  def text_filter
    if self[:text_filter_id] && !self[:text_filter_id].zero?
      TextFilter.find(self[:text_filter_id])
    else
      default_text_filter
    end
  end

  # Set the text filter for this object.
  def text_filter= filter
    self.text_filter_id = filter.to_text_filter.id
  end

  def blog
    @blog ||= Blog.default
  end

  def publish!
    self.published = true
    self.save!
  end

  def withdraw!
    self.withdraw
    self.save!
  end

  def published_at
    self[:published_at] || self[:created_at]
  end

  def send_notification_to_user(user)
    notify_user_via_email(user)
  end

  def really_send_notifications
    interested_users.each do |value|
      send_notification_to_user(value)
    end
    return true
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
    return unless self.published and self.redirects.count > 0
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

