module Admin::BaseHelper
  include ActionView::Helpers::DateHelper

  def subtabs_for(current_module)
    output = []
    AccessControl.project_module(current_user.profile.label, current_module).submenus.each_with_index do |m,i| 
      current = (m.url[:controller] == params[:controller] && m.url[:action] == params[:action]) ? "current" : ""
      output << subtab(_(m.name), current, m.url)
    end     
    content_for(:tasks) { output.join("\n") }
  end

  def subtab(label, style, options = {})
    content_tag :li, link_to(label, options, { "class"=> style })
  end

  def show_page_heading
    content_tag(:h2, @page_heading) unless @page_heading.blank?
  end

  def cancel(url = {:action => 'index'})
    link_to _("Cancel"), url
  end

  def save(val = _("Store"))
    '<input type="submit" value="' + val + '" class="submit" />'
  end

  def confirm_delete(val = _("Delete"))
   '<input type="submit" value="' + val + '" />'
  end

  def link_to_show(record, controller = @controller.controller_name)
    if record.published?
      link_to image_tag('admin/show.png', :alt => _("show"), :title => _("Show content")), 
        {:controller => controller, :action => 'show', :id => record.id}, 
        {:class => "lbOn"}
      end
  end

  def link_to_edit(label, record, controller = @controller.controller_name)
    link_to label, :controller => controller, :action => 'edit', :id => record.id
  end
  
  def link_to_edit_with_profiles(label, record, controller = @controller.controller_name)
    if current_user.admin? || current_user.id == record.user_id
      link_to label, :controller => controller, :action => 'edit', :id => record.id 
    end
  end

  def link_to_destroy(record, controller = @controller.controller_name)
    link_to image_tag('admin/delete.png', :alt => _("delete"), :title => _("Delete content")),
      :controller => controller, :action => 'destroy', :id => record.id
  end

  def link_to_destroy_with_profiles(record, controller = @controller.controller_name)
    if current_user.admin? || current_user.id == record.user_id
      link_to(_("delete"), 
        { :controller => controller, :action => 'destroy', :id => record.id }, :confirm => _("Are you sure?"), :method => :post, :title => _("Delete content"))
      end
  end

  def text_filter_options
    TextFilter.find(:all).collect do |filter|
      [ filter.description, filter ]
    end
  end

  def text_filter_options_with_id
    TextFilter.find(:all).collect do |filter|
      [ filter.description, filter.id ]
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

  def task_overview
    content_tag :li, link_to(_('Back to overview'), :action => 'index')
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

  def class_write
    if controller.controller_name == "content" or controller.controller_name == "pages"
      "current" if controller.action_name == "new"
    end
  end
  
  def class_content
    if controller.controller_name  =~ /content|pages|categories|resources/
      "current" if controller.action_name =~ /list|index|show/
    end
  end

  def class_feedback
    "current" if controller.controller_name  =~ /feedback/
  end

  def class_themes
    "current" if controller.controller_name  =~ /themes|sidebar/
  end
  
  def class_users
    controller.controller_name  =~ /users/ ? "current right" : "right"
  end

  def class_dashboard
    controller.controller_name  =~ /dashboard/ ? "current right" : "right"
  end    

  def class_settings
    controller.controller_name  =~ /settings|textfilter/ ? "current right" : "right"
  end
  
  def class_profile
    controller.controller_name  =~ /profiles/ ? "current right" : "right"
  end
  

  def t_textarea(object_name, method, options)
    return fckeditor_textarea(object_name, method, options) if current_user.editor == 'visual'
    text_area(object_name, method, options)
  end

  def alternate_editor
    return 'visual' if current_user.editor == 'simple'
    return 'simple'
  end
  
  def collection_select_with_current(object, method, collection, value_method, text_method, current_value, prompt=false)
    result = "<select name='#{object}[#{method}]'>\n" 
      
    if prompt == true
      result << "<option value=''>" << _("Please select") << "</option>"
    end
    for element in collection
      if current_value and current_value == element.send(value_method)
        result << "<option value='#{element.send(value_method)}' selected='selected'>#{element.send(text_method)}</option>\n" 
      else
        result << "<option value='#{element.send(value_method)}'>#{element.send(text_method)}</option>\n" 
      end
    end
    result << "</select>\n" 
    return result
  end

  def render_void_table(size, cols)
    if size == 0
      "<tr>\n<td colspan=#{cols}>" + _("There is no %s yet. Why don't you start and create one?", _(controller.controller_name)) + "</td>\n</tr>\n"
    end
  end
  
  def cancel_or_save
    result = '<p class="paginate r">'
    result << cancel 
    result << " "
    result << _("or") 
    result << " "
    result << save( _("Save") + " &raquo")
    result << '</p>'
    return result
  end
  
  def link_to_published(item)
    
    item.published? ? link_to_permalink(item, _("published"), '', 'published') : "<span class='unpublished'>#{_("unpublished")}</span>"  
  end
  
  def macro_help_popup(macro, text)
    unless current_user.editor == 'visual'
      "<a href=\"#{url_for :controller => 'textfilters', :action => 'macro_help', :id => macro.short_name}\" onclick=\"return popup(this, 'Typo Macro Help')\">#{text}</a>"
    end    
  end
  
  def render_macros(macros)
    result = link_to_function _("Show help on Typo macros") + " (+/-)",update_page { |page| page.visual_effect(:toggle_blind, "macros", :duration => 0.2) }
    result << "<table id='macros' style='display: none;'>"
    result << "<tr>"
    result << "<th>#{_('Name')}</th>"
    result << "<th>#{_('Description')}</th>"
    result << "<th>#{_('Tag')}</th>"
    result << "</tr>"
    
    for macro in macros.sort_by { |f| f.short_name }
      result << "<tr #{alternate_class}>"
      result << "<td>#{macro_help_popup macro, macro.display_name}</td>"
      result << "<td>#{h macro.description}</td>"
      result << "<td><code>&lt;typo:#{h macro.short_name}&gt;</code></td>"
      result << "</tr>"
    end
    result << "</table>"
  end
  
  def build_editor_link(label, action, id, update, editor)
    link = link_to_remote(label, 
            :url => { :action => action, 'editor' => editor}, 
            :loading => "new Element.show('update_spinner_#{id}')",
            :success => "new Element.toggle('update_spinner_#{id}')",
            :update => "#{update}")
    link << image_tag("spinner-blue.gif", :id => "update_spinner_#{id}", :style => 'display:none;')
  end
  
end
