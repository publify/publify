module Admin::CategoriesHelper
  def show_category_actions item
    content_tag(:div, {:class => 'action'}) do 
      [ button_to_edit(item),
        button_to_delete(item),
        link_to_permalink(item, "#{item.articles.size} <span class='glyphicon glyphicon-link'></span>".html_safe, nil, 'btn btn-success btn-xs').html_safe
        ].join(" ").html_safe
    end
  end
end
