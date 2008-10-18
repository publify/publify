require 'digest/sha1'
module ContentHelper
  def calc_distributed_class(articles, max_articles, grp_class, min_class, max_class)
    (grp_class.to_prefix rescue grp_class.to_s) +
      ((max_articles == 0) ?
           min_class.to_s :
         (min_class + ((max_class-min_class) * articles.to_f / max_articles).to_i).to_s)
  end

  def title_for_grouping(grouping)
    "#{pluralize(grouping.article_counter, _('no posts') , _('1 post'), __('%d posts'))} with #{grouping.class.to_s.underscore} '#{grouping.display_name}'"
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
    if !@page_title.blank?
      # this is where the page title prefix (string) should go
      (this_blog.title_prefix == 1 ? blog_name + " : " : '') + @page_title + (this_blog.title_prefix == 2 ? " : " + blog_name : '')
    else
      blog_name
    end
  end

  include SidebarHelper

  def article_links(article)
    returning code = [] do
      code << category_links(article)   unless article.categories.empty?
      code << tag_links(article)        unless article.tags.empty?
      code << comments_link(article)    if article.allow_comments?
      code << trackbacks_link(article)  if article.allow_pings?
    end.join("&nbsp;<strong>|</strong>&nbsp;")
  end

  def category_links(article)
    _("Posted in") + " " + article.categories.map { |c| link_to h(c.name), category_url(c), :rel => 'tag'}.join(", ")
  end

  def tag_links(article)
    _("Tags") + " " + article.tags.map { |tag| link_to tag.display_name, tag.permalink_url, :rel => "tag"}.sort.join(", ")
  end

  def next_link(article)
    n = article.next
    return  n ? link_to_permalink(n, "#{n.title} &raquo;") : ''
  end

  def prev_link(article)
    p = article.previous
    return p ? link_to_permalink(p, "&laquo; #{p.title}") : ''
  end

  def render_to_string(*args, &block)
    controller.send(:render_to_string, *args, &block)
  end
end
