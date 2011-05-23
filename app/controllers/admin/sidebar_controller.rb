class Admin::SidebarController < Admin::BaseController
  layout 'administration'

  def index
    @available = available
    # Reset the staged position based on the active position.
    Sidebar.delete_all('active_position is null')
    flash_sidebars
    begin
      @active = Sidebar.find(:all, :order => 'active_position ASC') unless @active
    rescue
      # Avoiding the view to crash
      @active = []
      flash[:error] = _("It seems something went wrong. Maybe some of your sidebars are actually missing and you should either reinstall them or remove them manually")
    end
  end

  def set_active
    # Get all available plugins
    klass_for = Hash[
      available.map {|klass| [klass.short_name, klass] }
    ]

    # Get all already active plugins
    activemap = Hash[
      flash_sidebars.map {|sb_id|
        sb = Sidebar.find(sb_id.to_i)
        sb ? [sb.html_id, sb_id] : nil
      }.compact
    ]

    # Figure out which plugins are referenced by the params[:active] array and
    # lay them out in a easy accessible sequential array
    flash[:sidebars] = params[:active].map {|name|
      if klass_for.has_key?(name)
        new_sidebar_id = klass_for[name].create.id
        @new_item = Sidebar.find(new_sidebar_id)
        new_sidebar_id
      elsif activemap.has_key?(name)
        activemap[name]
      end
    }.compact
  end

  def remove
    flash[:sidebars] = flash_sidebars.reject do |sb_id|
      sb_id == params[:id].to_i
    end
    @element_to_remove = params[:element]
  end

  def publish
    Sidebar.transaction do
      position = 0
      params[:configure] ||= { }
      # Crappy workaround to rails update_all bug with PgSQL / SQLite
      ActiveRecord::Base.connection.execute("update sidebars set active_position=null")
      flash_sidebars.each do |id|
        sidebar = Sidebar.find(id)
        sb_attribs = params[:configure][id.to_s] || {}
        # If it's a checkbox and unchecked, convert the 0 to false
        # This is ugly.  Anyone have an improvement?
        sidebar.fields.each do |field|
          sb_attribs[field.key] = field.canonicalize(sb_attribs[field.key])
        end

        sidebar.update_attributes(:config => sb_attribs,
                                  :active_position => position)
        position += 1
      end
      Sidebar.delete_all('active_position is null')
    end
    PageCache.sweep_all
    index
  end

  protected

  def show_available
    render :partial => 'availables', :object => available
  end

  def available
    ::Sidebar.available_sidebars
  end

  def flash_sidebars
    unless flash[:sidebars]
      begin
        active = Sidebar.find(:all, :order => 'active_position ASC')
        flash[:sidebars] = active.map {|sb| sb.id }
      rescue
        # Avoiding the view to crash
        @active = []
        flash[:error] = _("It seems something went wrong. Maybe some of your sidebars are actually missing and you should either reinstall them or remove them manually")
      end
    end
    flash[:sidebars]
  end

  helper_method :available
end
