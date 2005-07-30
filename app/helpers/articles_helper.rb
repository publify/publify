module ArticlesHelper
  
  def admin_tools_for(model)
    type = model.class.to_s.downcase
    tag = []
    tag << content_tag("div",
      link_to_remote('nuke', {
          :url => { :action => "nuke_#{type}", :id => model }, 
          :complete => visual_effect(:puff, "#{type}-#{model.id}", :duration => 0.6),
          :confirm => "Are you sure you want to delete this #{type}?"
        }, :class => "admintools") <<
      link_to('edit', {
        :controller => "admin/#{type.pluralize}/article/#{model.article.id}",
        :action => "edit", :id => model 
        }, :class => "admintools"),
      :id => "admin_#{type}_#{model.id}", :style => "display: none")
    tag.join(" | ")
  end

  def onhover_show_admin_tools(type, id = nil)
    tag = []
    tag << %{ onmouseover="if (getCookie('is_admin') == 'yes') { Element.show('admin_#{[type, id].compact.join('_')}'); }" }
    tag << %{ onmouseout="Element.hide('admin_#{[type, id].compact.join('_')}');" }
    tag
  end
  
  def render_errors(obj)
    return "" unless obj
    tag = String.new

    unless obj.errors.empty?
      tag << %{<ul class="objerrors">}

      obj.errors.each_full do |message| 
        tag << "<li>#{message}</li>"
      end

      tag << "</ul>"
    end

    tag
  end  
  
  def page_title
    if @page_title
      @page_title
    else
      config_value("blog_name") || "Typo"
    end    
  end
  
  def article_links(article)
    returning code = [] do
      code << category_links(article)   unless article.categories.empty?
      code << comments_link(article)    if article.allow_comments?
      code << trackbacks_link(article)  if article.allow_pings?
    end.join("&nbsp;<strong>|</strong>&nbsp;")
  end
  
  def category_links(article)
    "Posted in " + article.categories.collect { |c| link_to c.name,
      { :controller=>"articles", :action=>"category", :id=>c.permalink },
      :rel => "category tag"
    }.join(", ")
  end

  def author_link(article)
    if config['link_to_author'] and article.user and article.user.email.to_s.size>0 
      "<a href=\"mailto:#{article.user.email}\">#{article.user.name}</a>"
    elsif article.user and article.user.name.to_s.size>0
      article.user.name
    else
      article.author
    end
  end

end
