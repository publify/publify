class Admin::SidebarController < Admin::BaseController
  def index
    @sidebars = ::SidebarController.available_sidebars.inject({}) do |hash,sb|
      hash.merge({ sb.short_name => sb })
    end
    # Reset the staged position based on the active position.
    Sidebar.delete_all('active_position is null')
    @active = Sidebar.find(:all, :order => 'active_position').select do |sb|
      @sidebars[sb.controller]
    end
    flash[:sidebars] = @active.map {|sb| sb.id }
    @available = @sidebars.values.sort { |a,b| a.name <=> b.name }
  end

  def set_active
    # Get all available plugins

    defaults_for = available.inject({}) do |hash, item|
      hash.merge({ item.short_name => item.default_config })
    end
    # Get all already active plugins
    activemap = flash[:sidebars].inject({}) do |h, sb_id|
      sb = Sidebar.find(sb_id.to_i)
      sb ? h.merge({ sb.html_id => sb_id }) : h
    end

    # Figure out which plugins are referenced by the params[:active] array and
    # lay them out in a easy accessible sequential array
    flash[:sidebars] = params[:active].inject([]) do |array, name|
      if defaults_for.has_key?(name)
        @new_item = Sidebar.create!(:controller => name,
                                    :config => defaults_for[name])
        @target = name
        array << @new_item.id
      elsif activemap.has_key?(name)
        array << activemap[name]
      else
        array
      end
    end
  end

  def remove
    flash[:sidebars] = flash[:sidebars].reject do |sb_id|
      sb_id == params[:id].to_i
    end
    @element_to_remove = params[:element]
  end

  def publish
    Sidebar.transaction do
      position = 0
      params[:configure] ||= []
      Sidebar.update_all('active_position = null')
      flash[:sidebars].each do |id|
        Sidebar.find(id).update_attributes(:config => params[:configure][id.to_s],
                                           :active_position => position)
        position += 1
      end
      Sidebar.delete_all('active_position is null')
    end
    index
  end

  protected
  def show_available
    render :partial => 'availables', :object => available
  end

  def available
    ::SidebarController.available_sidebars.sort { |a,b| a.name <=> b.name }
  end
  helper_method :available
end
