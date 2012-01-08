module Admin::BaseHelper
  include ActionView::Helpers::DateHelper

  def subtabs_for(current_module)
    output = []
    AccessControl.project_module(current_user.profile_label, current_module).submenus.each_with_index do |m,i|
      current =
      output << subtab(_(m.name), (m.url[:controller] == params[:controller] && m.url[:action] == params[:action]) ? '' : m.url)
    end
    content_for(:tasks) { output.join("\n").html_safe }
  end

  def subtab(label, options = {})
    return content_tag :li, "<span class='subtabs'>#{label}</span>".html_safe if options.empty?
    content_tag :li, link_to(label, options)
  end

  def show_page_heading
    heading = ""
    heading << content_tag(:div, @link_to_new, :class => 'page_new') unless @link_to_new.blank?
    heading << content_tag(:h2, @page_heading, :class => 'page_heading') unless @page_heading.blank?
  end

  def cancel(url = {:action => 'index'})
    link_to _("Cancel"), url
  end

  def save(val = _("Store"))
    '<input type="submit" value="' + val + '" class="save" />'
  end

  def confirm_delete(val = _("Delete"))
   '<input type="submit" value="' + val + '" />'
  end

  def link_to_edit(label, record, controller = controller.controller_name)
    link_to label, {:controller => controller, :action => 'edit', :id => record.id}, :class => 'edit'
  end

  def link_to_edit_with_profiles(label, record, controller = controller.controller_name)
    if current_user.admin? || current_user.id == record.user_id
      link_to label, {:controller => controller, :action => 'edit', :id => record.id}, :class => 'edit'
    end
  end

  def link_to_destroy(record, controller = controller.controller_name)
    link_to image_tag('admin/delete.png', :alt => _("delete"), :title => _("Delete content")),
      :controller => controller, :action => 'destroy', :id => record.id
  end

  def link_to_destroy_with_profiles(record, controller = controller.controller_name)
    if current_user.admin? || current_user.id == record.user_id
      link_to(_("delete"),
        { :controller => controller, :action => 'destroy', :id => record.id }, :confirm => _("Are you sure?"), :method => :post, :title => _("Delete content"))
      end
  end

  def text_filter_options
    TextFilter.all.collect do |filter|
      [ filter.description, filter ]
    end
  end

  def text_filter_options_with_id
    TextFilter.all.collect do |filter|
      [ filter.description, filter.id ]
    end
  end

  def plugin_options(kind, blank = true)
    r = TypoPlugins::Keeper.available_plugins(kind).collect do |plugin|
      [ plugin.name, plugin.to_s ]
    end
    blank ? r << [_("none"),''] : r
  end

  def alternate_class
    @class = @class != '' ? '' : 'class="shade"'
  end

  def task_overview
    content_tag :li, link_to(_('Back to list'), :action => 'index')
  end

  def class_tab
    ''
  end

  def class_selected_tab
    'active'
  end

  def class_articles
    if controller.controller_name  =~ /content|tags|categories|feedback|post_type/
      return class_selected_tab if controller.action_name =~ /list|index|show|article|destroy|new|edit/
    end
    class_tab
  end

  def class_media
    if controller.controller_name  =~ /resources/
      return class_selected_tab
    end
    class_tab
  end

  def class_pages
    if controller.controller_name  =~ /pages/
      return class_selected_tab if controller.action_name =~ /index|destroy|new|edit/
    end
    class_tab
  end

  def class_themes
    return class_selected_tab if controller.controller_name  =~ /themes|sidebar/
    class_tab
  end

  def class_dashboard
    return class_selected_tab if controller.controller_name  =~ /dashboard/
    class_tab
  end

  def class_settings
    return class_selected_tab if controller.controller_name  =~ /settings|users|cache|redirects/
    class_tab
  end

  def class_profile
    return class_selected_tab if controller.controller_name  =~ /profiles/
    class_tab
  end

  def class_seo
    return class_selected_tab if controller.controller_name  =~ /seo/
    class_tab
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
      "<tr>\n<td colspan=#{cols}>" + _("There are no %s yet. Why don't you start and create one?", _(controller.controller_name)) + "</td>\n</tr>\n"
    end
  end

  def cancel_or_save
    result = '<p>'
    result << cancel
    result << " "
    result << _("or")
    result << " "
    result << save( _("Save") + " &raquo")
    result << '</p>'
    return result
  end

    def get_short_url(item)
      return "" if item.short_url.nil?
      sprintf("<small>%s %s</small>", _("Short url:"), link_to(item.short_url, item.short_url))
    end

  def show_actions item
    html = <<-HTML
      <div class='action'>
        <small>#{link_to_published item}</small> |
        <small>#{link_to _("Edit"), :action => 'edit', :id => item.id}</small> |
        <small>#{link_to _("Delete"), :action => 'destroy', :id => item.id}</small> |
        #{get_short_url item}
    </div>
    HTML
  end

  def format_date(date)
    date.strftime('%d/%m/%Y')
  end

  def format_date_time(date)
    date.strftime('%d/%m/%Y %H:%M')
  end

  def link_to_published(item)
    return link_to_permalink(item,  _("Show"), nil, 'published') if item.published
    link_to(_("Preview"), {:controller => '/articles', :action => 'preview', :id => item.id}, {:class => 'unpublished', :target => '_new'})
  end

  def published_or_not(item)
    return "<span class='published'>#{_("Published")}</span>" if item.published
    "<span class='unpublished'>#{_("Unpublished")}</span>"
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
            :class => 'ui-button-text',
            :loading => "new Element.show('update_spinner_#{id}')",
            :success => "new Element.toggle('update_spinner_#{id}')",
            :update => "#{update}")
    link << image_tag("spinner-blue.gif", :id => "update_spinner_#{id}", :style => 'display:none;')
  end

  def display_pagination(collection, cols, first='', last='')
    return "<tr><td class='#{first} #{last}' colspan=#{cols} class='paginate'>#{paginate(collection)}</td></tr>"
  end

  def show_thumbnail_for_editor(image)
    thumb = "#{::Rails.root.to_s}/public/files/thumb_#{image.filename}"
    picture = "#{this_blog.base_url}/files/#{image.filename}"

    image.create_thumbnail unless File.exists? thumb

    # If something went wrong with thumbnail generation, we just display a place holder
    thumbnail = (File.exists? thumb) ? "#{this_blog.base_url}/files/thumb_#{image.filename}" : "#{this_blog.base_url}/images/thumb_blank.jpg"

    picture = "<img class='tumb' src='#{thumbnail}' "
    picture << "alt='#{this_blog.base_url}/files/#{image.filename}' "
    picture << " onclick=\"edInsertImageFromCarousel('article_body_and_extended', '#{this_blog.base_url}/files/#{image.filename}');\" />"
    return picture
  end

  def save_settings
    "<p class='settings'>#{save(_("Update settings"))}</p>".html_safe
  end
end
