require 'observer'
require 'set'
class Content < ActiveRecord::Base
  include Observable

  belongs_to :text_filter
  validates_presence_of :blog_id

  has_and_belongs_to_many :notify_users, :class_name => 'User',
    :join_table => 'notifications', :foreign_key => 'notify_content_id',
    :association_foreign_key => 'notify_user_id', :uniq => true

  serialize :whiteboard

  @@content_fields = Hash.new
  @@html_map       = Hash.new

  def self.content_fields(*attribs)
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
    end
  end

  def self.html_map(field=nil)
    unless @@html_map[self]
      @@html_map[self] = Hash.new
      instance = self.new
      @@content_fields[self].each do |attrib|
        if instance.respond_to?("#{attrib}_html")
          @@html_map[self][attrib] = "#{attrib}_html"
        end
      end
    end
    if field
      @@html_map[self][field]
    else
      @@html_map[self]
    end
  end

  def self.find_published(what = :all, options = {})
    options[:conditions] = merge_conditions(['published = ?', true], options[:conditions])
    find(what, options)
  end

  def self.find_already_published(what = :all, at = Time.now, options = { })
    if what.respond_to?(:has_key?)
      options = what
      what = :all
      at = options.delete(:at) if options.has_key?(:at)
    elsif at.respond_to?(:has_key?)
      options = at
      at = options.delete(:at) || Time.now
    end
    options[:conditions] = merge_conditions(['created_at < ?', at], options[:conditions])
    options[:order] ||= 'created_at DESC'
    find_published(what, options)
  end

  def self.merge_conditions(*conditions)
    first_cond = conditions.shift.to_conditions_array
    conditions.compact.inject(first_cond) do |merged, cond|
      cond = cond.to_conditions_array
      merged.first << " AND ( #{cond.shift} )"
      merged + cond
    end
  end

  def html_map(field=nil); self.class.html_map(field); end

  def html(controller,what = :all)
    html_map.each do |field, html_field|
      if !self.send(field).blank? && self.send(html_field).blank?
        unformatted_value = self.send(field).to_s
        begin
          formatted_value = text_filter.filter_text_for_controller( unformatted_value, controller, self, false )
          formatted_value = self.send("%s_postprocess" % html_field, formatted_value, controller) if self.respond_to?("%s_postprocess" % html_field, true)
          self[html_field] = formatted_value
          save if self.id
        rescue
          self[html_field] = unformatted_value
        end
      end
    end

    if what == :all
      self.all_html rescue (self.body_html.to_s + (self.extended_html rescue nil).to_s)
    elsif self.class.html_map(what)
      self.send(html_map(what))
    else
      raise "Unknown 'what' in article.html"
    end
  end

  def whiteboard
    self[:whiteboard] ||= Hash.new
  end

  alias_method :orig_text_filter=, :text_filter=; alias_method :orig_text_filter, :text_filter

  def text_filter
    self.orig_text_filter ||= this_blog[default_text_filter_config_key].to_text_filter
  end

  def text_filter=(filter)
    self.orig_text_filter = filter.to_text_filter
  end

  def default_initialization
    if self.class.send(:scoped?, :create)
      self.class.send(:scope, :create)
    else
      { :blog_id => Blog.find(:first).id }
    end
  end

  def initialize(args=nil)
    args ||= { }
    args.reverse_merge!(default_initialization)
    super(args)
    yield self if block_given?
  end
end

class Object; def to_text_filter; TextFilter.find_by_name(self.to_s); end; end

class String; def to_conditions_array; ["(#{self})"]; end; end
class Array; def to_conditions_array; self; end; end
