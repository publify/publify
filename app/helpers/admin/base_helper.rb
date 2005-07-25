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

  def tab(label, options = {})    
    if controller.controller_name =~ /#{options[:controller].split('/').last}/
      content_tag :li, link_to(label, options, {"class"=> "active"}), {"class"=> "active"}
    else
      content_tag :li, link_to(label, options)      
    end    
  end    
  
  def cancel(url = {:action => 'list'})
    link_to "Cancel", url
  end

  def save(val = "Store")
    '<input type="submit" value="' + val + '" class="primary" />'
  end

  def confirm_delete(val = "Delete")
   '<input type="submit" value="' + val + '" />'
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
    text_filter_options << [ 'SmartyPants', 'smartypants' ] if defined?(RubyPants)
    text_filter_options << [ 'Markdown with SmartyPants', 'markdown smartypants' ] if defined?(RubyPants) and defined?(BlueCloth)
    text_filter_options
  end
  
  def alternate_class
    @class = @class != '' ? '' : 'class="shade"'
  end
  
  def task_quickpost(title)
    content_tag :li, link_to_function(title, toggle_effect('quick-post', 'Effect.BlindUp', "duration:0.4", "Effect.BlindDown", "duration:0.4"))
  end
  
  def task_quicknav(title)
    content_tag :li, link_to_function(title, toggle_effect('quick-navigate', 'Effect.BlindUp', "duration:0.4", "Effect.BlindDown", "duration:0.4"))
  end

  def task_overview
    task('Back to overview', 'list')
  end

  def task_new(title)
    task(title, 'new')
  end

  def task_destroy(title, id)
    task(title, 'destroy', id)
  end

  def task_edit(title, id)
    task(title, 'edit', id)
  end

  def task_show(title, id)
    task(title, 'show', id)
  end

  def task(title, action, id = nil)
    content_tag :li, link_to(title, :action => action, :id => id)
  end

end
