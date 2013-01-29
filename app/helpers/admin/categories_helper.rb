module Admin::CategoriesHelper
  def show_category_actions item
    content_tag(:div, {:class => 'action'}) do 
      [ content_tag(:small, link_to_permalink(item, pluralize(item.articles.size, _('no articles') , _('1 article'), __('%d articles')))),
        small_to_edit(item),
        small_to_delete(item),
        ].join(" | ").html_safe
    end
  end
end
