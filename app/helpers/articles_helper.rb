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
      { :controller=>"articles", :action=>"category", :id=>c.name },
      :rel => "category tag"
    }.join(", ")
  end

  # copied from ActionPack's pagination_helper.rb,
  # but passes each page to the given block instead of using link_to directly
  def pagination_custom_links(paginator, options={})
    options.merge!(ActionView::Helpers::PaginationHelper::DEFAULT_OPTIONS) {|key, old, new| old}

    window_pages = paginator.current.window(options[:window_size]).pages

    return if window_pages.length <= 1 unless
      options[:link_to_current_page]

    first, last = paginator.first, paginator.last

    returning html = '' do
      if options[:always_show_anchors] and not window_pages[0].first?
        html << yield(first)
        html << ' ... ' if window_pages[0].number - first.number > 1
        html << ' '
      end

      window_pages.each do |page|
        if paginator.current == page && !options[:link_to_current_page]
          html << page.number.to_s
        else
          html << yield(page)
        end
        html << ' '
      end

      if options[:always_show_anchors] && !window_pages.last.last?
        html << ' ... ' if last.number - window_pages[-1].number > 1
        html << yield(last)
      end
    end
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
