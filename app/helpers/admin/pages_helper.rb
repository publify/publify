module Admin::PagesHelper
  include ArticlesHelper
  
  def contents
    [@page]
  end
  
  def display_page_row(page)
    result = "<tr alternate_class>\n"
    result << "<td>#{link_to_permalink(page,page.title)}</td>\n"
    result << "<td>/pages/#{page.name}</td>\n"
    result << "<td>#{page.created_at.strftime('%d/%m/%Y at %H:%M')}</td>\n"
    result << "<td>#{author_link(page)}</td>\n"
    result << "<td class='operation'>" 
    if page.published?
      result << image_tag('admin/checked.png', :alt => "online", :title => _("Online")) 
    else
      result << image_tag('admin/cancel.png', :alt => "offline", :title => _("Offline")) 
    end 
    result << "</td>\n"
    result << "<td class='operation'>#{link_to image_tag('admin/show.png', :alt => 'View page', :title => 'Preview page'), {:action => 'show', :id => page.id}}</td>\n"
    result << "<td class='operation'>#{link_to_edit page}</td>\n"
    result << "<td class='operation'>#{link_to_destroy page}</td>\n"
    result << "</tr>\n"
    return result
  end
  
end
