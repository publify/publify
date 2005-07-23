require_dependency 'sidebars/sidebar_controller'

class Admin::SidebarController < Admin::BaseController
  def index
    @sidebars=Sidebars::SidebarController.available_sidebars.inject({}) do |h,sidebar|
      h[sidebar.short_name]=sidebar; h
    end

    @active=Sidebar.find_all_staged.select {|s| @sidebars[s.controller] }

    @available=@sidebars.values.sort { |a,b| a.name <=> b.name }
  end

  def show_available
    @available=Sidebars::SidebarController.available_sidebars.sort { |a,b| a.name <=> b.name }
    render :partial => 'available'
  end

  def show_waste
    render :partial => 'waste'
  end

  def set_active
    @active=Sidebar.find_all_staged
    activemap=Hash.new

    availablemap=available_types

    @active.each do |a|
      activemap[a.html_id]=a
    end
    @active=[]

    activelist=@params["active"]

    activelist.each do |name|
      if(name=~/HEADERHEADER/)
        # nothing -- this is the header.  It's technically a sortable
        # part of the container, but that's just to work around a
        # limitation in script.aculo.us's sortable
        # implementation--it's currently impossible to drag something
        # into an empty sortable.  So we cheat by making sure that the
        # header block is always in the sortable.  Yeah, it means that
        # users can drag things into a list *above* the header, but it
        # fixes itself soon enough.
      elsif(activemap[name])
        @active.push activemap[name]
      elsif (availablemap[name])
        newitem=Sidebar.new
        newitem.controller=name
        newitem.staged_config=availablemap[name].default_config

        @active.push newitem
      else
        raise "I don't know where to find #{name}"
      end
    end

    Sidebar.transaction do
      Sidebar.update_all('staged_position=null')
      @active.each_index do |i|
        @active[i].staged_position=i
        @active[i].save
      end
      Sidebar.purge
    end

    render :partial => 'active'
  end

  def save_config
    sidebar=Sidebar.find(params[:id])
    sidebar.staged_config=params[:configure]
    sidebar.save

    render_text ''
  end

  def nothing
    render_text ''
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
    Sidebars::SidebarController.available_sidebars
  end
  
  def available_types
    available.inject({}) { |h,i| h[i.short_name]=i; h }
  end
end
