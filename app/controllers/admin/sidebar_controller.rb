# coding: utf-8
class Admin::SidebarController < Admin::BaseController
  def index
    @available = available
    @ordered_sidebars = Sidebar.ordered_sidebars
    # Reset the staged position based on the active position.
    #Sidebar.delete_all('active_position is null')
    #flash_sidebars
  end

  # Just update a single active Sidebar instance at once
  def update
    sidebar_config = params[:configure]
    sidebar = Sidebar.where(id: params[:id]).first
    old_s_index = sidebar.staged_position || sidebar.active_position
    sidebar.update_attributes sidebar_config[sidebar.id.to_s]
    respond_to do |format|
      format.js do
        # render partial _target for it
        return render partial: 'target_sidebar', locals: { sortable_index: old_s_index, sidebar: sidebar}
      end
      format.html do
        return redirect_to(admin_sidebar_index_path)
      end
    end
  end

  def destroy
    sidebar = Sidebar.where(id: params[:id]).first
    sidebar && sidebar.destroy
    respond_to do |format|
      format.html { return redirect_to(admin_sidebar_index_path)}
      format.js { render js: {ok: :ok} }
    end
  end

  def set_active
    # Get all available plugins
    klass_for = available.inject({}) do |hash, klass|
      hash.merge({ klass.short_name => klass })
    end

    # Get all already active plugins
    activemap = flash_sidebars.inject({}) do |h, sb_id|
      sb = Sidebar.find(sb_id.to_i)
      sb ? h.merge(sb.html_id => sb_id) : h
    end

    # Figure out which plugins are referenced by the params[:active] array and
    # lay them out in a easy accessible sequential array
    flash[:sidebars] = params[:active].map do |name|
      if klass_for.has_key?(name)
        new_sidebar_id = klass_for[name].create.id
        @new_item = Sidebar.find(new_sidebar_id)
        new_sidebar_id
      elsif activemap.has_key?(name)
        activemap[name]
      end
    end.compact
  end

  def remove
    flash[:sidebars] = flash_sidebars.reject do |sb_id|
      sb_id == params[:id].to_i
    end
    @element_to_remove = params[:element]
  end

  def publish
    Sidebar.apply_staging_on_active!
    PageCache.sweep_all
    redirect_to admin_sidebar_index_path
  end

  # Callback for admin sidebar sortable plugin
  def sortable
    respond_to do |format|
      format.json do
        sorted = params[:sidebar].map(&:to_i)

        Sidebar.transaction do
          sorted.each_with_index do |sidebar_id, staged_index|
            # DEV NOTE : Ok, that's a HUGE hack. Sidebar.available are Class, not Sidebar instances. In order to use jQuery.sortable we need that hack: Sidebar.available is an Array, so it's ordered. I arbitrary shift by? IT'SOVER NINE THOUSAND! considering we'll never reach 9K Sidebar instances or Sidebar specializations
            sidebar = if sidebar_id >= 9000
              Sidebar.available_sidebars[sidebar_id - 9000].new
            else
              Sidebar.find(sidebar_id)
            end
            sidebar.update_attributes(staged_position: staged_index)
          end
        end

        @ordered_sidebars = Sidebar.ordered_sidebars
        @available = Sidebar.available_sidebars
        render json: { html: render_to_string('admin/sidebar/_config.html.erb', layout: false) }
      end
    end
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
      rescue => e
        logger.error e
        # Avoiding the view to crash
        @active = []
        flash[:error] = I18n.t('admin.sidebar.index.error')
      end
    end
    flash[:sidebars]
  end

  helper_method :available
end
