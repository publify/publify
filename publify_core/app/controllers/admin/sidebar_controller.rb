# frozen_string_literal: true

class Admin::SidebarController < Admin::BaseController
  def index
    @available = SidebarRegistry.available_sidebars
    @ordered_sidebars = Sidebar.ordered_sidebars
  end

  # Just update a single active Sidebar instance at once
  def update
    @sidebar = Sidebar.where(id: params[:id]).first
    @old_s_index = @sidebar.staged_position || @sidebar.active_position
    @sidebar.update params[:configure][@sidebar.id.to_s].permit!
    respond_to do |format|
      format.js
      format.html do
        return redirect_to(admin_sidebar_index_path)
      end
    end
  end

  def destroy
    @sidebar = Sidebar.where(id: params[:id]).first
    @sidebar&.destroy
    respond_to do |format|
      format.html { return redirect_to(admin_sidebar_index_path) }
      format.js
    end
  end

  def publish
    Sidebar.apply_staging_on_active!
    redirect_to admin_sidebar_index_path
  end

  # Callback for admin sidebar sortable plugin
  def sortable
    sorted = params[:sidebar].map(&:to_i)

    Sidebar.transaction do
      sorted.each_with_index do |sidebar_id, staged_index|
        # DEV NOTE : Ok, that's a HUGE hack. Sidebar.available are Class, not
        # Sidebar instances. In order to use jQuery.sortable we need that hack:
        # Sidebar.available is an Array, so it's ordered. I arbitrary shift by?
        # IT'S OVER NINE THOUSAND! considering we'll never reach 9K Sidebar
        # instances or Sidebar specializations
        sidebar = if sidebar_id >= 9000
                    SidebarRegistry.available_sidebars[sidebar_id - 9000].new(blog: this_blog)
                  else
                    Sidebar.valid.find(sidebar_id)
                  end
        sidebar.update(staged_position: staged_index)
      end
    end

    @ordered_sidebars = Sidebar.ordered_sidebars
    @available = SidebarRegistry.available_sidebars

    respond_to do |format|
      format.js
      format.html do
        return redirect_to admin_sidebar_index_path
      end
    end
  end
end
