module AuthorsHelper
  include BlogHelper

  def display_profile_item(item, item_desc)
    return if item.blank?
    item = link_to(item, item) if is_url?(item)
    content_tag :li do
      safe_join([item_desc, item], ' ')
    end
  end

  def is_url?(str)
    [URI::HTTP, URI::HTTPS].include?(URI.parse(str.to_s).class)
  rescue URI::InvalidURIError
    false
  end

  def author_description(user)
    return if user.description.blank?

    content_tag(:div, user.description, id: 'author-description')
  end

  def author_link(article)
    user = article.user
    if user.present? && user.name.present?
      h(user.name)
    else
      h(article.author)
    end
  end
end
