module AuthorsHelper

  def display_profile_item(item, item_desc)
    return unless item.present?
    item = link_to(item, item) if is_url?(item)
    content_tag :li do
      "#{item_desc} #{item.html_safe}".html_safe
    end
  end

  def is_url?(str)
    begin
      [URI::HTTP, URI::HTTPS].include?(URI.parse(str.to_s).class)
    rescue URI::InvalidURIError
      false
    end
  end
end
