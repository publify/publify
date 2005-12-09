require 'observer'
require 'set'

class Content < ActiveRecord::Base
  include Observable
  
  belongs_to :text_filter
  
  has_and_belongs_to_many :notify_users, :class_name => 'User',
    :join_table => 'notifications', :foreign_key => 'notify_content_id', 
    :association_foreign_key => 'notify_user_id', :uniq => true

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
      end
    end
    
    def html_map(field=nil)
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

    def find_published(what = :all, options = {})
      options[:conditions] = if options[:conditions]
                               merge_conditions(options[:conditions],
                                                ['published = ?', true])
                             else
                               ['published = ?', true]
                             end
      find(what, options)
    end

    def merge_conditions(cond_a, *rest)
      return cond_a if rest.empty?
      cond_a = ["(#{cond_a})"] if cond_a.is_a?(String)
      
      cond_b = rest.shift
      cond_b = [cond_b] if cond_b.is_a?(String)

      cond_a.first << " AND ( #{cond_b.shift} )"
      cond_a = cond_a + cond_b
      
      merge_conditions cond_a, *rest
    end
  end
  
  def html_map(field=nil); self.class.html_map(field); end
  
  def html(controller,what = :all)
    html_map.each do |field, html_field|
      if !self.send(field).blank? && self.send(html_field).blank?
        unformatted_value = self.send(field).to_s
        self[html_field] = 
          text_filter.filter_text_for_controller( unformatted_value, controller, false ) #rescue unformatted_value
        save if self.id
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
  
  alias_method :orig_text_filter, :text_filter
  
  def text_filter
    unless orig_text_filter
      self.text_filter = TextFilter.find_by_name(config[default_text_filter_config_key])
    end
    orig_text_filter  
  end
      
  
  def text_filter=(filter)
    if filter.nil?
      self.text_filter_id = nil
    elsif filter.kind_of? TextFilter
      self.text_filter_id = filter.id
    else
      filter = TextFilter.find_by_name(filter.to_s)
      self.text_filter_id = (filter.nil? ? nil : filter.id)
    end
    filter
  end
end
