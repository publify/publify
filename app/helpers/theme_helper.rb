# coding: utf-8
def render_active_page(page)
  if controller.action_name == 'view_page'
    return 'active' if params[:name].to_s == page
  end
end

def render_active_home
  if controller.controller_name == 'articles' and controller.action_name != 'view_page'
    if controller.action_name = 'index'
      return if params[:page]
      return 'active'
    end
  end
end

def render_active_articles
  return if controller.action_name == 'view_page'
  if controller.controller_name == 'articles' and controller.action_name == 'index'
    return unless params[:page]
  end
  return 'active'
end

def category_name(id)
  category = Category.find_by_permalink(id)
  category.name
end

def display_comments_counter(article)
  link_to pluralize(article.published_comments.size,
          _('%d comments', article.published_comments.size),
          _('%d comment', article.published_comments.size),
          _('%d comments', article.published_comments.size)), article.permalink_url
end

def show_pages_links
  html = ''.html_safe
  pages = Page.find(:all, :conditions => {:published => true})
  pages.each do |page|
    html << content_tag(:li, link_to_permalink(page, page.title, nil, render_active_page(page.name)))
  end
  html
end
