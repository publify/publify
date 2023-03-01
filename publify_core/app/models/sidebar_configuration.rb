# frozen_string_literal: true

require "sidebar_field"

class SidebarConfiguration
  attr_reader :config

  def initialize(config)
    @config = config
  end

  def content_partial
    "/#{self.class.path_name}/content"
  end

  def description
    self.class.description
  end

  def display_name
    self.class.display_name
  end

  def fieldmap(field = nil)
    if field
      self.class.fieldmap[field.to_s]
    else
      self.class.fieldmap
    end
  end

  def fields
    self.class.fields
  end

  def short_name
    self.class.short_name
  end

  def to_locals_hash
    fields.reduce(sidebar: self) do |hash, field|
      hash.merge(field.key => field.current_value(self))
    end
  end

  def parse_request(_contents, _params); end

  class << self
    attr_writer :fields
  end

  def self.short_name
    to_s.underscore.split(/_/).first
  end

  def self.path_name
    to_s.underscore
  end

  def self.display_name(new_dn = nil)
    @display_name = new_dn if new_dn
    @display_name || short_name.humanize
  end

  def self.setting(key, default = nil, options = {})
    key = key.to_s

    return if instance_methods.include?(key)

    fields << SidebarField.build(key, default, options)

    send(:define_method, key) do
      if config.key? key
        config[key]
      else
        default
      end
    end
  end

  def self.fields
    @fields ||= []
  end

  def self.description(desc = nil)
    if desc
      @description = desc
    else
      @description || ""
    end
  end
end
