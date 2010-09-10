module AuthorsHelper

  def display_profile_item(item, show_item, item_desc)
    if show_item
      item = link_to(item, item) if is_url?(item)
      content_tag :li do
        "#{item_desc} #{item}"
      end
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
