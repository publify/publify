require_dependency 'sidebars/sidebar_controller'

class Admin::SidebarController < Admin::BaseController
  def index
    @sidebars = Sidebars::SidebarController.available_sidebars.inject({}) do |hash,sidebar|
      hash[sidebar.short_name]=sidebar
      hash
    end

    @active = Sidebar.find_all_staged.select {|s| @sidebars[s.controller] }
    @available = @sidebars.values.sort { |a,b| a.name <=> b.name }
  end

  def show_available
    render :partial => 'availables', :object => available
  end

  def set_active

    # Get all available plugins
    availablemap = available.inject({}) do |hash, item|
      hash[item.short_name] = item
      hash
    end

    # Get all already active plugins
    activemap = Sidebar.find_all_staged.inject({}) do |hash, item|
      hash[item.html_id] = item
      hash
    end

    # Figure out which plugins are referenced by the params[:active] array and
    # lay them out in a easy accessible sequencial array
    @active = params[:active].inject([]) do |array, name|
      if availablemap.has_key?(name)
        newitem = Sidebar.new
        newitem.controller = name
        newitem.staged_config= availablemap[name].default_config

        array.push newitem
      elsif activemap.has_key?(name)
        array.push activemap[name]
      end
      array
    end

    # Update the staged_position of all the sidebar items in accordance with
    # the params[:active] array
    Sidebar.transaction do
      Sidebar.update_all('staged_position=null')
      @active.each_index do |i|
        @active[i].staged_position=i
        @active[i].save
      end
      Sidebar.purge
    end

    render :partial => 'actives', :object => @active
  end

  def save_config
    sidebar = Sidebar.find(params[:id])
    sidebar.staged_config=params[:configure]
    sidebar.save

    render :nothing => true
  end

  def nothing
    render :nothing => true
  end

  def remove
    sidebar = Sidebar.find(params[:id])
    sidebar.staged_position = nil
    sidebar.save

    render :nothing => true
  end

  def publish
    Sidebar.transaction do
      Sidebar.find(:all).each do |sidebar|
        sidebar.publish
        sidebar.save
      end
      Sidebar.purge
    end
    render :partial=>'publish'
  end

  private

  def available
    Sidebars::SidebarController.available_sidebars.sort { |a,b| a.name <=> b.name }
  end
end
