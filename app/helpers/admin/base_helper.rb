module Admin::BaseHelper
  include ActionView::Helpers::DateHelper

  def state_class(item)
    item.state.to_s
  end

  def render_flash
    output = []

    for key,value in flash
      output << "<span class=\"#{key.to_s.downcase}\">#{value}</span>"
    end if flash

    output.join("<br/>\n")
  end

  def render_tasks
     output = []

      for key,value in @tasks
      output << "<a href=\"#{value}\">#{key}</a>"
    end if @tasks

    output.join("<br />\n")
  end

  def current_user_notice
    unless current_user
      link_to "log in", :controller => "/accounts", :action=>"login"
    else
      link_to _("log out"), :controller => "/accounts", :action=>"logout"
    end
  end

  def tab(label, options = {})
    if controller.controller_name =~ /#{options[:controller].split('/').last}/
      content_tag :li, link_to(label, options, {"class"=> ""}), {"class"=> ""}
    else
      content_tag :li, link_to(label, options)
    end
  end
  
  def subtab(label, style, options = {})
    content_tag :li, link_to(label, options, {"class"=> style})
  end

  def cancel(url = {:action => 'list'})
    link_to _("Cancel"), url
  end

  def save(val = "Store")
    '<input type="submit" value="' + val + '" class="submit" />'
  end

  def confirm_delete(val = "Delete")
   '<input type="submit" value="' + val + '" />'
  end

  def link_to_show(record, controller = @controller.controller_name)
    link_to image_tag('admin/show.png', :alt => "show", :title => "Show content"), 
      :controller => controller, :action => 'show', :id => record.id
  end

  def link_to_edit(record, controller = @controller.controller_name)
    link_to image_tag('admin/edit.png', :alt => "edit", :title => "Edit content"),
      :controller => controller, :action => 'edit', :id => record.id
  end

  def link_to_destroy(record, controller = @controller.controller_name)
    link_to image_tag('admin/delete.png', :alt => "delete", :title => "Delete content"),
      :controller => controller, :action => 'destroy', :id => record.id
  end

  def text_filter_options
    TextFilter.find(:all).collect do |filter|
      [ filter.description, filter ]
    end
  end

  def alternate_class
    @class = @class != '' ? '' : 'class="shade"'
  end

  def reset_alternation
    @class = nil
  end

  def task_quickpost(title)
    link_to_function(title, toggle_effect('quick-post', 'Effect.BlindUp', "duration:0.4", "Effect.BlindDown", "duration:0.4"))
  end

  def task_quicknav(title)
    content_tag :li, link_to_function(title, toggle_effect('quick-navigate', 'Effect.BlindUp', "duration:0.4", "Effect.BlindDown", "duration:0.4"))
  end

  def task_overview
    task(_('Back to overview'), 'list')
  end

  def task_new(title)
    task(title, 'new')
  end

  def task_destroy(title, id)
    task(title, 'destroy', id)
  end

  def task_edit(title, id)
    task(title, 'edit', id)
  end

  def task_show(title, id)
    task(title, 'show', id)
  end

  def task_help(title, id)
    task(title, 'show_help', id)
  end

  def task(title, action, id = nil)
    content_tag :li, link_to(title, :action => action, :id => id)
  end

  def task_add_resource_metadata(title,id)
    link_to_function(title, toggle_effect('add-resource-metadata-' + id.to_s, 'Effect.BlindUp', "duration:0.4", "Effect.BlindDown", "duration:0.4"))
  end

  def task_edit_resource_metadata(title,id)
    link_to_function(title, toggle_effect('edit-resource-metadata-' + id.to_s, 'Effect.BlindUp', "duration:0.4", "Effect.BlindDown", "duration:0.4"))
  end

  def task_edit_resource_mime(title,id)
    link_to_function(title, toggle_effect('edit-resource-mime-' + id.to_s, 'Effect.BlindUp', "duration:0.4", "Effect.BlindDown", "duration:0.4"))
  end

  def time_delta_from_now_in_words(timestamp)
    distance_of_time_in_words_to_now(timestamp) + ((Time.now < timestamp) ? ' from now' : ' ago')
  end

  def link_to_bookmarklet
    "javascript:if(navigator.userAgent.indexOf('Safari') >= 0)" + \
    "{Q=getSelection();}" + \
    "else{Q=document.selection?document.selection.createRange().text:document.getSelection();}" + \
    "location.href='#{this_blog.base_url}/admin/content/new?bookmarklet_text='+encodeURIComponent(Q)" + \
    "+'&bookmarklet_link='+encodeURIComponent(location.href)+'&bookmarklet_title='+encodeURIComponent(document.title);"
  end
    
  def class_write
    if controller.controller_name == "content" or controller.controller_name == "pages"
      if controller.action_name == "new"
        "current"
      end
    end
  end
  
  def class_manage
    if controller.controller_name  =~ /content|pages|categories|resources/
      if controller.action_name =~ /list|index|show/
        "current"
      end
    end
  end

  def class_feedback
    if controller.controller_name  =~ /feedback/
    "current"
    end
  end

  def class_themes
    if controller.controller_name  =~ /themes/
    "current"
    end
  end

  def class_plugins
    if controller.controller_name  =~ /sidebar|textfilter/
    "current"
    end
  end
  
  def class_users
    if controller.controller_name  =~ /users/
    "current"
    end
  end

  def class_dashboard
    if controller.controller_name  =~ /dashboard/
    "current"
    end
  end    

  def class_admin
    if controller.controller_name  =~ /settings/
    "current"
    end
  end
  
  def order_link(title, controller, action, order)
    link_to _(title), :controller => controller, :action => action, :order => order, :sense => (params[:sense] and params[:sense] == 'asc') ?  'desc' : 'asc'
  end
end
