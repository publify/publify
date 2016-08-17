require 'sidebar_field'

# This class cannot be autoloaded since other sidebar classes depend on it.
class Sidebar < ActiveRecord::Base
  serialize :config, Hash

  belongs_to :blog

  scope :valid, ->() { where(type: SidebarRegistry.available_sidebar_types) }

  def self.ordered_sidebars
    os = []
    Sidebar.valid.each do |s|
      if s.staged_position
        os[s.staged_position] = ((os[s.staged_position] || []) << s).uniq
      elsif s.active_position
        os[s.active_position] = ((os[s.active_position] || []) << s).uniq
      end
      if s.active_position.nil? && s.staged_position.nil?
        s.destroy # neither staged nor active: destroy. Full stop.
      end
    end
    os.flatten.compact
  end

  def self.purge
    delete_all('active_position is null and staged_position is null')
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

    send(:define_method, "#{key}=") do |newval|
      config[key] = newval
    end
  end

  def self.fields
    @fields ||= []
  end

  def self.description(desc = nil)
    if desc
      @description = desc
    else
      @description || ''
    end
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

  class << self
    attr_writer :fields
  end

  def self.apply_staging_on_active!
    Sidebar.transaction do
      Sidebar.find_each do |s|
        s.active_position = s.staged_position
        s.save!
      end
    end
  end

  def publish
    self.active_position = staged_position
  end

  def html_id
    short_name + '-' + id.to_s
  end

  def parse_request(_contents, _params)
  end

  def fields
    self.class.fields
  end

  def fieldmap(field = nil)
    if field
      self.class.fieldmap[field.to_s]
    else
      self.class.fieldmap
    end
  end

  def description
    self.class.description
  end

  def short_name
    self.class.short_name
  end

  def display_name
    self.class.display_name
  end

  def content_partial
    "/#{self.class.path_name}/content"
  end

  def to_locals_hash
    fields.reduce(sidebar: self) do |hash, field|
      hash.merge(field.key => config[field.key])
    end
  end

  def admin_state
    return :active if active_position && (staged_position == active_position || staged_position.nil?)
    return :will_change_position if active_position != staged_position
    raise "Unknown admin_state: active: #{active_position}, staged: #{staged_position}"
  end
end
