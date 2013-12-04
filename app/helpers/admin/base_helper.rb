module Admin::BaseHelper
  include ActionView::Helpers::DateHelper

  def tab_for(current_module)
    content_tag(:li, link_to(_(current_module.menu_name), current_module.menu_url))    
  end

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

  def cancel(url = {:action => 'index'})
    link_to _("Cancel"), url, :class => 'btn'
  end

  def save(val = _("Store"))
    submit_tag(val, :class => 'btn btn-success')
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
    r = PublifyPlugins::Keeper.available_plugins(kind).collect do |plugin|
      [ plugin.name, plugin.to_s ]
    end
    blank ? r << [_("none"),''] : r
  end

  def task_overview
    content_tag :li, link_to(_('Back to list'), :action => 'index')
  end

  def render_void_table(size, cols)
    return unless size == 0
    content_tag(:tr) do
      content_tag(:td, _("There are no %s yet. Why don't you start and create one?", _(controller.controller_name)), { colspan: cols})
    end
  end

  def cancel_or_save(message=_("Save"))
    "#{cancel} #{_("or")} #{save(message)}"
  end

  def get_short_url(item)
    return "" if item.short_url.nil?
    sprintf(content_tag(:small, "%s %s"), _("Short url:"), link_to(item.short_url, item.short_url, only_path: false))
  end

  def show_actions item
    content_tag(:div, { :class => 'action', :style => '' }) do
      [ button_to_edit(item),
        button_to_delete(item),
        button_to_short_url(item) ].join(" ").html_safe
    end
  end

  def format_date(date)
    date.strftime('%d/%m/%Y')
  end

  def format_date_time(date)
    date.strftime('%d/%m/%Y %H:%M')
  end

  def link_to_published(item, show=_("Show"), preview=_("Preview"))
    return link_to_permalink(item, show, nil, 'published') if item.published

    type = controller.controller_name == 'content' ? "" : "_page"

    link_to(preview, {:controller => '/articles', :action => "preview#{type}", :id => item.id}, {:class => 'unpublished', :target => '_new'})
  end

  def published_or_not(item)
    return content_tag(:span, t(".published"), class: 'label label-success') if item.state.to_s.downcase == 'published'
    return content_tag(:span, t(".draft"), class: 'label label-info') if item.state.to_s.downcase == 'draft'
    return content_tag(:span, t(".withdrawn"), class: 'label label-important') if item.state.to_s.downcase == 'withdrawn'
    return content_tag(:span, t(".publication_pending"), class: 'label label-warning') if item.state.to_s.downcase == 'publicationpending'
  end

  def macro_help_popup(macro, text)
    "<a href=\"#{url_for :controller => 'textfilters', :action => 'macro_help', :id => macro.short_name}\" onclick=\"return popup(this, 'Publify Macro Help')\">#{text}</a>"
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
    content_tag(:div, cancel_or_save(_("Update settings")).html_safe, :class => 'form-group')
  end

  def button_to_edit(item)
    link_to(content_tag(:span, '', class: 'glyphicon glyphicon-pencil'), {action: 'edit', id: item.id}, {class: 'btn btn-primary btn-xs btn-action'})
  end

  def button_to_delete(item)
    link_to(content_tag(:span, '', class: 'glyphicon glyphicon-trash'), {action: 'destroy', id: item.id}, {class: 'btn btn-danger btn-xs btn-action'})
  end

  def button_to_short_url(item)
    return "" if item.short_url.nil?
    link_to(content_tag(:span, '', class: 'glyphicon glyphicon-link'), item.short_url, {class: 'btn btn-success btn-xs btn-action'})
  end

  def button_to_show(item)
    link_to_permalink(item,  content_tag(:span, '', class: 'glyphicon glyphicon-link'), nil, 'btn btn-success btn-xs btn-action')
  end

  def twitter_available?(blog, user)
    blog.has_twitter_configured? && user.has_twitter_configured?
  end

  def twitter_disabled_message(blog, user)
    unless twitter_available?(blog, user)
      content_tag(:p, _("If you want to push short statuses on Twitter, you need to %s Twitter gave you after you %s.", link_to(_("fill in the oauth credentials"), :controller => 'admin/settings', action: 'write'), link_to(_("registered your application"), "https://dev.twitter.com/apps/new")).html_safe, class: 'alert alert-warning')
    end
  end
end
