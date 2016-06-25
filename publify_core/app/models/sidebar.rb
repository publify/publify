# frozen_string_literal: true

class Sidebar < ApplicationRecord
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
    delete_all("active_position is null and staged_position is null")
  end

  def self.apply_staging_on_active!
    Sidebar.transaction do
      Sidebar.find_each do |s|
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

  delegate :content_partial, to: :configuration

  delegate :display_name, to: :configuration

  delegate :description, to: :configuration

  delegate :fields, to: :configuration

  def publish
    self.active_position = staged_position
  end

  def html_id
    "#{short_name}-#{id}"
  end

  delegate :parse_request, to: :configuration

  def admin_state
    if active_position && (staged_position == active_position || staged_position.nil?)
      return :active
    end
    return :will_change_position if active_position != staged_position

    raise "Unknown admin_state: active: #{active_position}, staged: #{staged_position}"
  end
end
