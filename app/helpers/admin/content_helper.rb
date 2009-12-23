module Admin::ContentHelper
  include ArticlesHelper

  def contents
    [@article]
  end

  def params_qsa
    { 'search[category]' => @search[:category],
      'search[user_id]' => @search[:user_id],
      'search[published_at]' => @search[:published_at],
      'searched[published]' => @search[:published] }
  end

  def link_to_destroy_draft(record, controller = @controller.controller_name)
    if record.state.to_s == "Draft"
      link_to(_("Destroy this draft"),
        { :controller => controller, :action => 'destroy', :id => record.id },
          :confirm => _("Are you sure?"), :method => :post )
    end
  end

  def auto_complete_result(entries, field, phrase = nil)
    return unless entries
    items = entries.map { |entry| content_tag("li", phrase ? highlight(entry[field], phrase) : h(entry[field])) }
    content_tag("ul", items.uniq)
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

  def text_field_with_auto_complete(object, method, tag_options = {}, completion_options = {})
    (completion_options[:skip_style] ? "" : auto_complete_stylesheet) +
    text_field(object, method, tag_options) +
    content_tag("div", "", :id => "#{object}_#{method}_auto_complete", :class => "auto_complete") +
    auto_complete_field("#{object}_#{method}", { :url => { :action => "auto_complete_for_#{object}_#{method}" } }.update(completion_options))
  end

  def auto_complete_stylesheet
    content_tag('style', <<-EOT, :type => Mime::CSS)
      div.auto_complete {
        width: 350px;
        background: #fff;
      }
      div.auto_complete ul {
        border:1px solid #888;
        margin:0;
        padding:0;
        width:100%;
        list-style-type:none;
      }
      div.auto_complete ul li {
        margin:0;
        padding:3px;
      }
      div.auto_complete ul li.selected {
        background-color: #ffb;
      }
      div.auto_complete ul strong.highlight {
        color: #800;
        margin:0;
        padding:0;
      }
    EOT
  end
end
