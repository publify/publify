module Admin::ContentHelper
  def link_to_destroy_draft(record, controller = controller.controller_name)
    return unless record.state.to_s.downcase == "draft"
    link_to(_("Destroy this draft"),
      { :controller => controller, :action => 'destroy', :id => record.id },
        :confirm => _("Are you sure?"), :method => :post, :class => 'btn danger' )
  end

  def auto_complete_result(entries, field, phrase = nil)
    return unless entries
    items = entries.map { |entry| content_tag("li", phrase ? highlight(entry[field], phrase) : h(entry[field])) }
    content_tag("ul", items.uniq.join.html_safe, {:class => 'unstyled', :id => 'autocomplete'})
  end

  def auto_complete_field(field_id, options = {})
    function =  "var #{field_id}_auto_completer = new Ajax.Autocompleter("
    function << "'#{field_id}', "
    function << "'" + (options[:update] || "#{field_id}_auto_complete") + "', "
    function << "'#{url_for(options[:url])}'"

    js_options = {}
    js_options[:tokens] = array_or_string_for_javascript(options[:tokens]) if options[:tokens]
    js_options[:callback]   = "function(element, value) { return #{options[:with]} }" if options[:with]
    js_options[:indicator]  = "'#{options[:indicator]}'" if options[:indicator]
    js_options[:select]     = "'#{options[:select]}'" if options[:select]
    js_options[:paramName]  = "'#{options[:param_name]}'" if options[:param_name]
    js_options[:frequency]  = "#{options[:frequency]}" if options[:frequency]
    js_options[:method]     = "'#{options[:method].to_s}'" if options[:method]

    { :after_update_element => :afterUpdateElement,
      :on_show => :onShow, :on_hide => :onHide, :min_chars => :minChars }.each do |k,v|
      js_options[v] = options[k] if options[k]
    end

    function << (', ' + options_for_javascript(js_options) + ')')

    javascript_tag(function)
  end
  
  def get_post_types
    post_types = @post_types || []
    if post_types.size.zero?
      return hidden_field_tag "article[post_type]", "read"
    end
    
    html = "<div class='well'>"
    html << content_tag(:h4, _("Article type"))
    html << "<select name=article[post_type]>"
        
    post_types.each do |pt|
      html << "<option value='read' #{'selected' if @article.post_type == 'read'} >#{_('Default')}</option>"
      html << "<option #{'selected' if @article.post_type == pt.permalink} value='#{pt.permalink}'>#{pt.name}</option>"
    end
    
    html << "</select>"
    html << "</div>"
  end  
end
