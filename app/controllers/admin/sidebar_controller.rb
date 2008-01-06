class Admin::SidebarController < Admin::BaseController
  def index
    @available = available
    # Reset the staged position based on the active position.
    Sidebar.delete_all(['blog_id = ? and active_position is null',
                         this_blog.id])
    @active = this_blog.sidebars
    flash[:sidebars] = @active.map {|sb| sb.id }
  end

  def set_active
    # Get all available plugins

    klass_for = available.inject({}) do |hash, klass|
      hash.merge({ klass.short_name => klass })
    end
    # Get all already active plugins
    activemap = flash[:sidebars].inject({}) do |h, sb_id|
      sb = Sidebar.find(sb_id.to_i)
      sb ? h.merge(sb.html_id => sb_id) : h
    end

    # Figure out which plugins are referenced by the params[:active] array and
    # lay them out in a easy accessible sequential array
    flash[:sidebars] = params[:active].inject([]) do |array, name|
      if klass_for.has_key?(name)
        @new_item = klass_for[name].create!(:blog => this_blog)
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
      params[:configure] ||= { }
      # Crappy workaround to rails update_all bug with PgSQL / SQLite
#      this_blog.sidebars.update_all('active_position = null')
      ActiveRecord::Base.connection.execute("update sidebars set active_position=null where blog_id = #{this_blog.id}")
      flash[:sidebars].each do |id|
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
      Sidebar.delete_all(['blog_id = ? and active_position is null',
                          this_blog.id])
    end
    index
  end

  protected
  def show_available
    render :partial => 'availables', :object => available
  end

  def available
    ::Sidebar.available_sidebars
  end
  helper_method :available
end
