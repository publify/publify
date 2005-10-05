require 'observer'
require 'set'

class Content < ActiveRecord::Base
  include Observable  
  
  belongs_to :text_filter

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
  end
  
  def html_map(field=nil); self.class.html_map(field); end
  
  
  def html(controller,what = :all)
    html_map.each do |field, html_field|
      if !self.send(field).blank? && self.send(html_field).blank?
        unformatted_value = self.send(field).to_s
        formatted_value =
          text_filter.filter_text_for_controller( \
            unformatted_value, controller, false, self ) rescue unformatted_value
        if self.id
          self.update_attribute html_field, formatted_value
        else
          self[html_field] = formatted_value
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
