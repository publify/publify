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

  def checkbox_for_collection(container, selected = nil)
    container = container.to_a if Hash === container

    options_for_select = container.inject([]) do |options, element|
      text, value = option_text_and_value(element)
      selected_attribute = ' checked' if option_value_selected?(value, selected)
      options << %(<input type="checkbox" name="categories[]" id="category_#{html_escape(value.to_s)}" value="#{html_escape(value.to_s)}"#{selected_attribute} /><label for="category_#{html_escape(value.to_s)}">#{html_escape(text.to_s)}</label>)
    end

    options_for_select.join("<br />")
  end

  def checkboxes_from_collection(collection, value_method, text_method, selected = nil)
    options = collection.map do |element|
      [element.send(text_method), element.send(value_method)]
    end
    checkbox_for_collection(options, selected)
  end
end
