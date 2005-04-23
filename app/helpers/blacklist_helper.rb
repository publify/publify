module BlacklistHelper
  
  def cancel(url = {:action => 'list'})
    "<input type=\"button\" value=\"Cancel\" style=\"width: auto;\" onclick=\"window.location.href = '#{url_for url}';\" />"
  end

  def save
    '<input type="submit" value="OK" class="primary" />'
  end

  def confirm_delete
   '<input type="submit" value="Delete" />'
  end

  def link_to_show(record)
    link_to 'Show', :action => 'show', :id => record.id
  end  

  def link_to_edit(record)
    link_to 'Edit', :action => 'edit', :id => record.id
  end  

  def link_to_destroy(record)
    link_to 'Delete', :action => 'destroy', :id => record.id
  end    
  
end
