require 'sidebar_field'

# This class cannot be autoloaded since other sidebar classes depend on it.
class Sidebar < ActiveRecord::Base
  self.inheritance_column = :bogus
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

  def self.apply_staging_on_active!
    Sidebar.transaction do
      Sidebar.all.each do |s|
        s.active_position = s.staged_position
        s.save!
      end
    end
  end

  def configuration_class
    type.constantize
  end

  def configuration
    @configuration ||= configuration_class.new(config)
  end

  def content_partial
    configuration.content_partial
  end

  def display_name
    configuration.display_name
  end

  def description
    configuration.description
  end

  def fields
    configuration.fields
  end

  def publish
    self.active_position = staged_position
  end

  def html_id
    short_name + '-' + id.to_s
  end

  def parse_request(contents, params)
    configuration.parse_request(contents, params)
  end

  def admin_state
    return :active if active_position && (staged_position == active_position || staged_position.nil?)
    return :will_change_position if active_position != staged_position
    raise "Unknown admin_state: active: #{active_position}, staged: #{staged_position}"
  end
end
