# coding: utf-8
class Admin::SidebarController < Admin::BaseController
  def index
    @available = available
    @ordered_sidebars = Sidebar.ordered_sidebars
  end

  # Just update a single active Sidebar instance at once
  def update
    sidebar_config = params[:configure]
    sidebar = Sidebar.where(id: params[:id]).first
    old_s_index = sidebar.staged_position || sidebar.active_position
    sidebar.update_attributes sidebar_config[sidebar.id.to_s].permit!
    respond_to do |format|
      format.js do
        # render partial _target for it
        return render partial: 'target_sidebar', locals: { sortable_index: old_s_index, sidebar: sidebar }
      end
      format.html do
        return redirect_to(admin_sidebar_index_path)
      end
    end
  end

  def destroy
    @sidebar = Sidebar.where(id: params[:id]).first
    @sidebar && @sidebar.destroy
    respond_to do |format|
      format.html { return redirect_to(admin_sidebar_index_path) }
      format.js
    end
  end

  def publish
    Sidebar.apply_staging_on_active!
    PageCache.sweep_all
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
                    Sidebar.available_sidebars[sidebar_id - 9000].new
                  else
                    Sidebar.valid.find(sidebar_id)
                  end
        sidebar.update_attributes(staged_position: staged_index)
      end
    end

    @ordered_sidebars = Sidebar.ordered_sidebars
    @available = Sidebar.available_sidebars
    respond_to do |format|
      format.json do
        render json: { html: render_to_string('admin/sidebar/_config.html.erb', layout: false) }
      end
      format.html do
        return redirect_to admin_sidebar_index_path
      end
    end
  end

  protected

  # TODO: Rename and move to a AdminSidebarHelpers module. Or use in instance variable.
  def available
    ::Sidebar.available_sidebars
  end

  helper_method :available
end
