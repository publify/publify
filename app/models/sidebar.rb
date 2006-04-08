class Sidebar < ActiveRecord::Base
#  acts_as_list
  serialize :config

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
    self.active_position=self.staged_position
  end

  def sidebar_controller
    @sidebar_controller ||= SidebarController.available_sidebars.find { |s| s.short_name == self.controller }
  end

  def config
    self[:config]||{}
  end

  def html_id
    controller+'-'+id.to_s
  end
end
