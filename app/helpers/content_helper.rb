require 'digest/sha1'
module ContentHelper
  def calc_distributed_class(articles, max_articles, grp_class, min_class, max_class)
    (grp_class.to_prefix rescue grp_class.to_s) +
      ((max_articles == 0) ?
           min_class.to_s :
         (min_class + ((max_class-min_class) * articles.to_f / max_articles).to_i).to_s)
  end

  def link_to_grouping(grp)
    link_to( grp.display_name, urlspec_for_grouping(grp),
             :rel => "tag", :title => title_for_grouping(grp) )
  end

  def urlspec_for_grouping(grouping)
    { :controller => "/articles", :action => grouping.class.to_prefix, :id => grouping.permalink }
  end

  def title_for_grouping(grouping)
    "#{pluralize(grouping.article_counter, 'post')} with #{grouping.class.to_s.underscore} '#{grouping.display_name}'"
  end

  def ul_tag_for(grouping_class)
    case
    when grouping_class == Tag
      %{<ul id="taglist" class="tags">}
    when grouping_class == Category
      %{<ul class="categorylist">}
    else
      '<ul>'
    end
  end

  def page_title
    blog_name = this_blog.blog_name || "Typo"
    if @page_title
      # this is where the page title prefix (string) should go
      (this_blog.title_prefix == 1 ? blog_name + " : " : '') + @page_title + (this_blog.title_prefix == 2 ? " : " + blog_name : '')
    else
      blog_name
    end
  end

  include SidebarHelper

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

  def article_links(article)
    returning code = [] do
      code << category_links(article)   unless article.categories.empty?
      code << tag_links(article)        unless article.tags.empty?
      code << comments_link(article)    if article.allow_comments?
      code << trackbacks_link(article)  if article.allow_pings?
    end.join("&nbsp;<strong>|</strong>&nbsp;")
  end

  def category_links(article)
    "Posted in " + article.categories.map { |c| link_to h(c.name), category_url(c), :rel => 'tag'}.join(", ")
  end

  def tag_links(article)
    "Tags " + article.tags.map { |tag| link_to tag.display_name, tag.permalink_url, :rel => "tag"}.sort.join(", ")
  end

  def next_link(article)
    n = article.next
    return  n ? n.link_to_permalink("#{n.title} &raquo;") : ''
  end

  def prev_link(article)
    p = article.previous
    return p ? n.link_to_permalink("&laquo; #{p.title}") : ''
  end

  def render_to_string(*args, &block)
    controller.send(:render_to_string, *args, &block)
  end
end
