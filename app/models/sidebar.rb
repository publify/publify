require_dependency 'sidebars/sidebar_controller'

class Sidebar < ActiveRecord::Base
#  acts_as_list
  serialize :active_config
  serialize :staged_config

  def self.find_all_visible
    find :all, :conditions => 'active_position is not null', :order => 'active_position'
  end

  def self.find_all_staged
    find :all, :conditions => 'staged_position is not null', :order => 'staged_position'
  end

  def self.purge
    delete_all('active_position is null and staged_position is null')
  end

  def publish
    self.active_config=self.staged_config
    self.active_position=self.staged_position
  end

  def sidebar_controller
    @sidebar_controller||=Sidebars::SidebarController.available_sidebars.find { |s| s.short_name == self.controller }
  end

  def active_config
    self[:active_config]||{}
  end

  def html_id
    controller+'-'+id.to_s
  end
end
