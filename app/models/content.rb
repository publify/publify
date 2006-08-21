require 'observer'
require 'set'

# Used to get access to the Fragment Cache from inside of content models.
class ContentCache
  include ActionController::Caching::Fragments

  class << self
    include ActionController::Benchmarking::ClassMethods

    def logger
      RAILS_DEFAULT_LOGGER
    end
  end

  def perform_caching
    ENV['RAILS_ENV'] == 'production'
  end

  def [](key)
    return unless key
    read_fragment(key)
  end

  def []=(key,value)
    return unless key
    if value
      write_fragment(key,value)
    else
      expire_fragment(key)
    end
  end
end

class Content < ActiveRecord::Base
  include Observable

  belongs_to :text_filter
  belongs_to :blog
  validates_presence_of :blog_id

  composed_of :state, :class_name => 'ContentState::Factory',
    :mapping => %w{ state memento }

  has_and_belongs_to_many :notify_users, :class_name => 'User',
    :join_table => 'notifications', :foreign_key => 'notify_content_id',
    :association_foreign_key => 'notify_user_id', :uniq => true

  has_many :triggers, :as => :pending_item, :dependent => :delete_all

  before_save :state_before_save
  after_save :post_trigger, :state_after_save

  serialize :whiteboard

  @@content_fields = Hash.new
  @@html_map       = Hash.new
  @@cache = ContentCache.new

  def initialize(*args, &block)
    super(*args, &block)
    set_default_blog
  end

  def cache_read(field)
    @@cache[cache_key(field)]
  end

  def cache_write(field,value)
    @@cache[cache_key(field)]=value
  end

  def set_default_blog
    if self.blog_id == nil or self.blog_id == 0
      self.blog = Blog.default
    end
  end

  class << self
    # Quite a bit of this isn't needed anymore.
    def content_fields(*attribs)
      @@content_fields[self] = ((@@content_fields[self]||[]) + attribs).uniq
      @@html_map[self] = nil
      attribs.each do | field |
        define_method("#{field}=") do | newval |
          if self[field] != newval
            changed
            self[field] = newval
            if html_map(field)
              cache_write(field,nil)
            end
            notify_observers(self, field.to_sym)
          end
          self[field]
        end
        unless self.method_defined?("#{field}_html")
          define_method("#{field}_html") do
            typo_deprecated "Use html(:#{field})"
            html(field.to_sym)
          end
        end
      end
    end

    def html_map(field=nil)
      unless @@html_map[self]
        @@html_map[self] = Hash.new
        instance = self.new
        @@content_fields[self].each do |attrib|
          @@html_map[self][attrib] = true
        end
      end
      if field
        @@html_map[self][field]
      else
        @@html_map[self]
      end
    end

    def find_published(what = :all, options = {})
      options.reverse_merge!(:order => default_order)
      options[:conditions] = merge_conditions(['published = ?', true],
                                              options[:conditions])
      options[:include] ||= []
      options[:include] += [:blog]
      find(what, options)
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

    def merge_conditions(*conditions)
      conditions.compact.collect do |cond|
        '(' + sanitize_sql(cond) + ')'
      end.join(' AND ')
    end
  end

  def content_fields
    @@content_fields[self.class]
  end

  def state_before_save
    state.before_save(self)
  end

  def state_after_save
    state.after_save(self)
  end

  def html_map(field=nil)
    self.class.html_map(field)
  end

  def cache_key(field)
    id ? "contents_html/#{id}/#{field}" : nil
  end

  # Return HTML for some part of this object.  It will be fetched from the
  # cache if possible, or regenerated if needed.
  def html(field = :all)
    if field == :all
      content_fields.map{|f| html(f)}.join("\n")
    elsif self.class.html_map(field)
      generate_html(field)
    else
      raise "Unknown field: #{field.inspect} in article.html"
    end
  end

  # Generate HTML for a specific field using the text_filter in use for this
  # object.  The HTML is cached in the fragment cache, using the +ContentCache+
  # object in @@cache.
  def generate_html(field)
    html = cache_read(field)
    return html if html

    html = text_filter.filter_text_for_controller(blog, self[field].to_s, self)
    html ||= self[field].to_s # just in case the filter puked
    html = html_postprocess(field,html).to_s

    cache_write(field,html)

    html
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
    blog.text_filter.to_text_filter
  end

  # Grab the text filter for this object.  It's either the filter specified by
  # self.text_filter_id, or the default specified in the blog object.
  def text_filter
    if self[:text_filter_id]
      self[:text_filter] ||= TextFilter.find(self[:text_filter_id]) rescue nil
    end
    self[:text_filter] ||= default_text_filter
  end

  # Set the text filter for this object.
  def text_filter=(filter)
    self[:text_filter_id] = filter.to_text_filter.id
    self[:text_filter] = filter.to_text_filter
  end

  # FIXME -- this feels wrong.
  def blog
    self[:blog] ||= blog_id.to_i.zero? ? Blog.default : Blog.find(blog_id)
  end

  def state=(newstate)
    if state
      state.exit_hook(self, newstate)
    end
    @state = newstate
    self[:state] = newstate.memento
    newstate.enter_hook(self)
    @state
  end

  def publish!
    self.published = true
    self.save!
  end

  def withdraw
    state.withdraw(self)
  end

  def withdraw!
    self.withdraw
    self.save!
  end

  def published=(a_boolean)
    self[:published] = a_boolean
    state.change_published_state(self, a_boolean)
  end

  def published_at=(a_time)
    state.set_published_at(self, (a_time.to_time rescue nil))
  end

  def published_at
    self[:published_at] || self[:created_at]
  end

  def published?
    state.published?(self)
  end

  def just_published?
    state.just_published?
  end

  def just_changed_published_status?
    state.just_changed_published_status?
  end

  def withdrawn?
    state.withdrawn?
  end

  def publication_pending?
    state.publication_pending?
  end

  def post_trigger
    state.post_trigger(self)
  end

  def after_save
    state.after_save(self)
  end

  def send_notification_to_user(user)
    notify_user_via_email(user)
    notify_user_via_jabber(user)
  end

  def send_notifications()
    state.send_notifications(self)
  end

  # deprecated
  def full_html
    typo_deprecated "use .html instead"
    html
  end

end

class Object
  def to_text_filter
    TextFilter.find_by_name(self.to_s) || TextFilter.find_by_name('none')
  end
end

class ContentTextHelpers
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
end

