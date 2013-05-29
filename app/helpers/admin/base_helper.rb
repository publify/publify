module Admin::BaseHelper
  include ActionView::Helpers::DateHelper

  def subtabs_for(current_module)
    output = ""
    AccessControl.submenus_for(current_user.profile_label, current_module).each do |m|
      if m.current_url?(params[:controller], params[:action])
        output << content_tag(:li, link_to(_(m.name), '#'), class: 'active')
      else
        output << content_tag(:li, link_to(_(m.name), m.url))
      end
    end
    output
  end

  def show_page_heading
    return if @page_heading.nil? or @page_heading.blank?

    content_tag(:div, {:class => 'page-header'}) do
      content_tag(:h2, @page_heading.html_safe)
    end
  end

  def cancel(url = {:action => 'index'})
    link_to _("Cancel"), url, :class => 'btn'
  end

  def save(val = _("Store"))
    submit_tag(val, :class => 'btn btn-primary')
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
        { controller: controller, action: 'destroy', id: record.id },
        data: {confirm: _("Are you sure?")},
        method: :post, class: 'btn danger', title: _("Delete content"))
      end
  end

  def text_filter_options
    TextFilter.all.collect do |filter|
      [ _(filter.description), filter ]
    end
  end

  def text_filter_options_with_id
    TextFilter.all.collect do |filter|
      [ _(filter.description), filter.id ]
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

  def render_void_table(size, cols)
    return unless size == 0
    content_tag(:tr) do
      content_tag(:td, _("There are no %s yet. Why don't you start and create one?", _(controller.controller_name)), { :colspan => cols})
    end
  end

  def cancel_or_save(message=_("Save"))
    "#{cancel} #{_("or")} #{save(message)}"
  end

    def get_short_url(item)
      return "" if item.short_url.nil?
      sprintf(content_tag(:small, "%s %s"), _("Short url:"), link_to(item.short_url, item.short_url))
    end

  def show_actions item
    content_tag(:div, { :class => 'action', :style => '' }) do
      [ content_tag(:small, link_to_published(item)),
        small_to_edit(item),
        small_to_delete(item),
        get_short_url(item) ].join(" | ").html_safe
    end
  end

  def format_date(date)
    date.strftime('%d/%m/%Y')
  end

  def format_date_time(date)
    date.strftime('%d/%m/%Y %H:%M')
  end

  def link_to_published(item)
    return link_to_permalink(item,  _("Show"), nil, 'published') if item.published

    type = controller.controller_name == 'content' ? "" : "_page"

    link_to(_("Preview"), {:controller => '/articles', :action => "preview#{type}", :id => item.id}, {:class => 'unpublished', :target => '_new'})
  end

  def published_or_not(item)
    return content_tag(:small, _("Published"), :class => 'label label-success') if item.state.to_s.downcase == 'published'
    return content_tag(:small, _("Draft"), :class => 'label label-info') if item.state.to_s.downcase == 'draft'
    return content_tag(:small, _("Withdrawn"), :class => 'label label-important') if item.state.to_s.downcase == 'withdrawn'
    return content_tag(:small, _("Publication pending"), :class => 'label label-warning') if item.state.to_s.downcase == 'publicationpending'
  end

  def macro_help_popup(macro, text)
    unless current_user.editor == 'visual'
      "<a href=\"#{url_for :controller => 'textfilters', :action => 'macro_help', :id => macro.short_name}\" onclick=\"return popup(this, 'Typo Macro Help')\">#{text}</a>"
    end
  end

  def render_macros(macros)
    content_tag(:div) do
      link_to_function(_("Show help on Typo macros") + " (+/-)", update_page { |page| page.visual_effect(:toggle_blind, "macros", :duration => 0.2) })
      content_tag(:table, {:id => 'macros', :style => 'display: none'}) do
        content_tag(:tr) do
          content_tag(:th, _('Name'))
          content_tag(:th, _('Description'))
          content_tag(:th, _('Tag'))
        end
        for macro in macros.sort_by { |f| f.short_name }
          content_tag(:tr, {:class => alternate_class}) do
            content_tag(:td, macro_help_popup(macro, macro.display_name))
            content_tag(:td, h(macro.description))
            content_tag(:td, content_tag(:code, "&lt;#{h(macro.short_name)}&gt;"))
          end
        end
      end
    end
  end

  def build_editor_link(label, action, id, update, editor)
    link = link_to_remote(label,
            :url => { :action => action, 'editor' => editor},
            :method => :get,
            :class => 'ui-button-text',
            :loading => "new Element.show('update_spinner_#{id}')",
            :success => "new Element.toggle('update_spinner_#{id}')",
            :update => "#{update}")
    link << image_tag("spinner-blue.gif", :id => "update_spinner_#{id}", :style => 'display:none;')
  end

  def display_pagination(collection, cols, first='', last='')
    return if collection.count == 0
    content_tag(:tr) do
      content_tag(:td, paginate(collection), {:class => 'paginate', :colspan => cols})
    end
  end

  def show_thumbnail_for_editor(image)
    picture = "<a onclick=\"edInsertImageFromCarousel('article_body_and_extended', '#{image.upload.url}');\" />"
    picture << "<img class='tumb' src='#{image.upload.thumb.url}' "
    picture << "alt='#{image.upload.url}' />"
    picture << "</a>"

    return picture
  end

  def save_settings
    content_tag(:div, cancel_or_save(_("Update settings")).html_safe)
  end

  def small_to_edit(item)
    content_tag(:small, link_to(_("Edit"), :action => 'edit', :id => item.id))
  end

  def small_to_delete(item)
    content_tag(:small, link_to(_("Delete"), {:action => 'destroy', :id => item.id}, :class => 'delete'))
  end
end
