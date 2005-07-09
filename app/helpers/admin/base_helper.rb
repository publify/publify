module Admin::BaseHelper

  def render_flash
    output = []
    
    for key,value in @flash
      output << "<span class=\"#{key.downcase}\">#{value}</span>"
    end if @flash
      
    output.join("<br/>\n")
  end

  def render_tasks
     output = []

      for key,value in @tasks
   	  output << "<a href=\"#{value}\">#{key}</a>"
   	end if @tasks
   	  
   	output.join("<br/>\n")
  end
       
  def current_user_notice
    unless session[:user]
      link_to "log in", :controller => "/accounts", :action=>"login"
    else
      link_to "log out", :controller => "/accounts", :action=>"logout"
    end
  end

  def link_to_section(label, options = {})
        
    if controller.controller_name == options[:controller]
      link_to(label, options, {"class"=> "active"})
    else
      link_to(label, options)      
    end
    
  end    
  
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
    link_to image_tag('go'), :action => 'show', :id => record.id
  end  

  def link_to_edit(record)
    link_to image_tag('go'), :action => 'edit', :id => record.id
  end  

  def link_to_destroy(record)
    link_to image_tag('delete'), :action => 'destroy', :id => record.id
  end    

  def text_filter_options  
    text_filter_options = Array.new
    text_filter_options << [ 'None', 'none' ]
    text_filter_options << [ 'Textile', 'textile' ] if defined?(RedCloth)
    text_filter_options << [ 'Markdown', 'markdown' ] if defined?(BlueCloth)

    text_filter_options
  end
end
