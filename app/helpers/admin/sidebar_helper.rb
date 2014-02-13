module Admin::SidebarHelper
  def class_for_admin_state(sidebar, this_position)
    case sidebar.admin_state
    when :active
      return 'active alert-info'
    when :will_change_position
      if this_position == sidebar.active_position
        return 'will_change ghost'
      else
        return 'will_change alert-warning'
      end
    else
      raise sidebar.admin_state.inspect
    end
  end
end
