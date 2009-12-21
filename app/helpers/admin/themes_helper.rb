module Admin::ThemesHelper
  require('find')
  def fetch_stylesheets
    list = ''
    Find.find(this_blog.current_theme.path + "/stylesheets") do |path|
      if path =~ /css$/ 
        list << content_tag(:p, link_to(File.basename(path), {:controller => 'themes', :action => 'editor', :type => 'stylesheet', :file => File.basename(path)}))
      end
    end
    list
  end

  def fetch_layouts
    list = ''
    Find.find(this_blog.current_theme.path + "/layouts") do |path|
      if path =~ /rhtml$|erb$/ 
        list << content_tag(:p, link_to(File.basename(path), {:controller => 'themes', :action => 'editor', :type => 'layout', :file => File.basename(path)}))
      end
    end
    list
  end
  
end
