module Admin::CategoriesHelper
  def show_category_actions item
    html = <<-HTML
      <div class='action'>
        <small>#{link_to_permalink item, pluralize(item.articles.size, _('no articles') , _('1 article'), __('%d articles'))}</small> |
        <small>#{link_to _("Edit"), :action => 'edit', :id => item.id}</small> |
        <small>#{link_to _("Delete"), :action => 'destroy', :id => item.id}</small>
    </div>
    HTML
  end

end
