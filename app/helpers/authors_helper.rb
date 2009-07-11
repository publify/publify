module AuthorsHelper

  def display_profile_item(item, show_item, item_desc)
    content_tag :li do
      "#{item_desc} #{item}"
    end if show_item
  end
end
