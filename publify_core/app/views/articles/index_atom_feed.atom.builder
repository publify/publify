# frozen_string_literal: true

atom_feed(language: this_blog.lang.split('_').first, root_url: this_blog.base_url) do |feed|
  render 'shared/atom_header', feed: feed, items: @articles

  @articles.each do |item|
    render 'shared/atom_item_article', feed: feed, item: item
  end
end
