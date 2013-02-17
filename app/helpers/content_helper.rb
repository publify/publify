require 'digest/sha1'
module ContentHelper
  def category_links(article, prefix="Posted in")
    _(prefix) + " " + article.categories.map { |c| link_to h(c.name), c.permalink_url(nil, true), :rel => 'tag'}.join(", ")
  end

  def tag_links(article, prefix="Tags")
    _(prefix) + " " + article.tags.map { |tag| link_to tag.display_name, tag.permalink_url(nil, true), :rel => "tag"}.sort.join(", ")
  end

  def next_link(article, prefix="")
    n = article.next
    prefix = (prefix.blank?) ? "#{n.title} &raquo;" : prefix
    return  n ? link_to_permalink(n, prefix) : ''
  end

  def prev_link(article, prefix="")
    p = article.previous
    prefix = (prefix.blank?) ? "&laquo; #{p.title}" : prefix
    return p ? link_to_permalink(p, prefix) : ''
  end

  def render_to_string(*args, &block)
    controller.send(:render_to_string, *args, &block)
  end
end
