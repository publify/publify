class SidebarController < ApplicationController
  def index
    if flash[:sidebars]
      @sidebars = flash[:sidebars].map {|sb_id| Sidebar.find(sb_id.to_i) }
      flash.keep(:sidebars)
    else
      @sidebars = self.class.enabled_sidebars
    end
    render :action => 'display_plugins'
  end

  def display_plugins
    @sidebars=self.class.enabled_sidebars
    render :layout => false
  end

  def at
    @sidebar = self.class.enabled_sidebars[params[:id].to_i]
    render :action => 'show'
  end

  def show
    @sidebar = Sidebar.find(params[:id].to_i)
    unless @sidebar
      render :text => "No such sidebar", :status => 404
    end
  end

  def self.enabled_sidebars
    available=available_sidebars.inject({}) { |h,i| h[i.short_name]=i; h}

    Sidebar.find_all_visible.select do |sidebar|
      sidebar.controller and available[sidebar.controller]
    end
  end

  def self.available_sidebars
    Sidebars::Plugin.available_sidebars
  end

  protected

  def log_processing
    logger.info "\n\nProcessing #{controller_class_name}\##{action_name} (for #{request_origin})"
  end
end

Dir["#{RAILS_ROOT}/components/plugins/sidebars/[_a-z]*.rb"].each do |f|
  require_dependency f
end
