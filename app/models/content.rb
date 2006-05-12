require 'observer'
require 'set'
class Content < ActiveRecord::Base
  include Observable

  belongs_to :text_filter
  belongs_to :blog
  validates_presence_of :blog_id

  has_and_belongs_to_many :notify_users, :class_name => 'User',
    :join_table => 'notifications', :foreign_key => 'notify_content_id',
    :association_foreign_key => 'notify_user_id', :uniq => true

  has_many :triggers, :as => :pending_item, :dependent => :delete_all

  before_save :state_before_save
  after_save :post_trigger

  serialize :whiteboard

  @@content_fields = Hash.new
  @@html_map       = Hash.new

  class << self
    def content_fields(*attribs)
      @@content_fields[self] = ((@@content_fields[self]||[]) + attribs).uniq
      @@html_map[self] = nil
      attribs.each do | field |
        define_method("#{field}=") do | newval |
          if self[field] != newval
            changed
            self[field] = newval
            if html_map(field)
              self[html_map(field)] = nil
            end
            notify_observers(self, field.to_sym)
          end
          self[field]
        end
        unless self.method_defined?("#{field}_html")
          define_method("#{field}_html") do
            if blog.controller
              html(blog.controller, field.to_sym)
            else
              self["#{field}_html"]
            end
          end
        end
      end
    end

    def html_map(field=nil)
      unless @@html_map[self]
        @@html_map[self] = Hash.new
        instance = self.new
        @@content_fields[self].each do |attrib|
          @@html_map[self][attrib] = "#{attrib}_html"
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

  def state
    @state ||= ContentState::Factory.derived_from(self)
  end

  def state=(new_state)
    @state = new_state
  end

  def state_before_save
    self.state.before_save(self)
  end

  def html_map(field=nil); self.class.html_map(field); end

  def full_html
    unless blog.controller
      raise "full_html only works with an active controller"
    end
    html(blog.controller, :all)
  end

  def populate_html_fields(controller)
    html_map.each do |field, html_field|
      if !self[field].blank? && self[html_field].blank?
        html = text_filter.filter_text_for_controller( self[field].to_s, controller, self, false )
        self[html_field] = self.send("#{html_field}_postprocess",
                                     html, controller)
      end
    end
  end

  def html(controller,what = :all)
    populate_html_fields(controller)

    if what == :all
      self[:body_html].to_s + (self[:extended_html].to_s rescue '')
    elsif self.class.html_map(what)
      self[html_map(what)]
    else
      raise "Unknown 'what' in article.html"
    end
  end

  def method_missing(method, *args, &block)
    if method.to_s =~ /_postprocess$/
      args[0]
    else
      super(method, *args, &block)
    end
  end

  def whiteboard
    self[:whiteboard] ||= Hash.new
  end


  def text_filter
    self[:text_filter] ||= if self[:text_filter_id]
                             TextFilter.find(self[:text_filter_id])
                           else
                             blog[default_text_filter_config_key].to_text_filter
                           end
  end

  def text_filter=(filter)
    self[:text_filter] = filter.to_text_filter
  end

  def blog
    self[:blog] ||= blog_id.to_i.zero? ? Blog.default : Blog.find(blog_id)
  end

  def publish!
    self.published = true
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

  def just_published?
    state.just_published?
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

  def send_notification_to_user(controller, user)
    notify_user_via_email(controller, user)
    notify_user_via_jabber(controller, user)
  end

  def send_notifications(controller = nil)
    state.send_notifications(self, controller || blog.controller)
  end
end

class Object; def to_text_filter; TextFilter.find_by_name(self.to_s); end; end
