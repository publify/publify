module Admin::BaseHelper
  include ActionView::Helpers::DateHelper

  def toggle_element(element, label = t('.change'))
    link_to(label, "##{element}", :"data-toggle" => :collapse)
  end

  def dashboard_action_links
    links = []
    links << link_to(t('.write_a_post'), controller: 'content', action: 'new') if current_user.can_access_to_articles?
    links << link_to(t('.write_a_page'), controller: 'pages', action: 'new') if current_user.can_access_to_pages?
    links << link_to(t('.update_your_profile_or_change_your_password'), controller: 'profiles', action: 'index')
    links.join(', ')
  end

  def show_redirect_actions(item)
    content_tag(:div, class: 'action') do
      [button_to_edit(item),
       button_to_delete(item)].join(' ').html_safe
    end
  end

  def show_rss_description
    Article.first.get_rss_description rescue ''
  end

  def show_tag_actions(item)
    content_tag(:div, class: 'action') do
      [button_to_edit(item),
       button_to_delete(item),
       link_to_permalink(item, "#{item.articles.size} <span class='glyphicon glyphicon-link'></span>".html_safe, nil, 'btn btn-success btn-xs').html_safe
      ].join(' ').html_safe
    end
  end

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

  def tab_for(current_module)
    content_tag(:li, link_to(current_module.menu_name, current_module.menu_url))
  end

  def subtabs_for(current_module)
    output = ''
    AccessControl.submenus_for(current_user.profile_label, current_module).each do |m|
      if m.current_url?(params[:controller], params[:action])
        output << content_tag(:li, link_to(m.name, '#'), class: 'active')
      else
        output << content_tag(:li, link_to(m.name, m.url))
      end
    end
    output
  end

  def link_to_edit(label, record, controller_name = controller.controller_name)
    link_to label, { controller: controller_name, action: 'edit', id: record.id }, { class: 'edit' }
  end

  def link_to_edit_with_profiles(label, record, controller_name = controller.controller_name)
    if current_user.admin? || current_user.id == record.user_id
      link_to label, { controller: controller_name, action: 'edit', id: record.id }, { class: 'edit' }
    end
  end

  def text_filter_options
    TextFilter.all.collect do |filter|
      [filter.description, filter]
    end
  end

  def text_filter_options_with_id
    TextFilter.all.collect do |filter|
      [filter.description, filter.id]
    end
  end

  def plugin_options(kind)
    PublifyPlugins::Keeper.available_plugins(kind).collect do |plugin|
      [plugin.name, plugin.to_s]
    end
  end

  def show_actions(item)
    content_tag(:div,  class: 'action', style: '') do
      [button_to_edit(item),
       button_to_delete(item),
       button_to_short_url(item)].join(' ').html_safe
    end
  end

  def macro_help_popup(macro, text)
    "<a href=\"#{url_for controller: 'textfilters', action: 'macro_help', id: macro.short_name}\" onclick=\"return popup(this, 'Publify Macro Help')\">#{text}</a>"
  end

  def display_pagination(collection, cols, _first = '', _last = '')
    return if collection.count == 0
    content_tag(:tr) do
      content_tag(:td, paginate(collection), class: 'paginate', colspan: cols)
    end
  end

  def show_thumbnail_for_editor(image)
    picture = "<a onclick=\"edInsertImageFromCarousel('article_body_and_extended', '#{image.upload.url}');\" />"
    picture << "<img class='tumb' src='#{image.upload.thumb.url}' "
    picture << "alt='#{image.upload.url}' />"
    picture << '</a>'

    picture
  end

  def button_to_edit(item)
    link_to(content_tag(:span, '', class: 'glyphicon glyphicon-pencil'), { action: 'edit', id: item.id }, { class: 'btn btn-primary btn-xs btn-action' })
  end

  def button_to_delete(item)
    link_to(content_tag(:span, '', class: 'glyphicon glyphicon-trash'), { action: 'destroy', id: item.id }, { class: 'btn btn-danger btn-xs btn-action' })
  end

  def button_to_short_url(item)
    return '' if item.short_url.nil?
    link_to(content_tag(:span, '', class: 'glyphicon glyphicon-link'), item.short_url, class: 'btn btn-success btn-xs btn-action')
  end

  def twitter_available?(blog, user)
    blog.has_twitter_configured? && user.has_twitter_configured?
  end
end
