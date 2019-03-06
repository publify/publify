# frozen_string_literal: true

atom_feed root_url: this_blog.base_url do |feed|
  render "shared/atom_header", feed: feed, items: @feedback

  @feedback.each do |item|
    render "shared/atom_item_#{item.type.downcase}", feed: feed, item: item
  end
end
