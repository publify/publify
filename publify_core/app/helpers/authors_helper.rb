# frozen_string_literal: true

module AuthorsHelper
  include BlogHelper

  def display_profile_item(item, item_desc)
    return if item.blank?

    item = link_to(item, item) if is_url?(item)
    tag.li do
      safe_join([item_desc, item], " ")
    end
  end

  def is_url?(str)
    [URI::HTTP, URI::HTTPS].include?(URI.parse(str.to_s).class)
  rescue URI::InvalidURIError
    false
  end

  def author_description(user)
    return if user.description.blank?

    tag.div(user.description, id: "author-description")
  end

  def author_link(article)
    h(article.author_name)
  end
end
