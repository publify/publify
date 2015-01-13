module AuthorsHelper
  def display_profile_item(item, item_desc)
    return unless item.present?
    item = link_to(item, item) if is_url?(item)
    content_tag :li do
      "#{item_desc} #{item.html_safe}".html_safe
    end
  end

  def is_url?(str)
    [URI::HTTP, URI::HTTPS].include?(URI.parse(str.to_s).class)
  rescue URI::InvalidURIError
    false
  end

  def author_description(user)
    return unless user.description.present?

    content_tag(:div, user.description, id: 'author-description')
  end

  def author_link(article)
    return h(article.author) if just_author?(article.user)
    return h(article.user.name) if just_name?(article.user)
    content_tag(:a, href: "mailto:#{h article.user.email}") { h(article.user.name) }
  end

  private

  def just_author?(author)
    author.nil? || author.name.blank?
  end

  def just_name?(author)
    author.present? && !this_blog.link_to_author
  end

  def this_blog
    @blog ||= Blog.default
  end
end
