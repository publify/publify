atom_feed root_url: author_url(@author) do |feed|
  render 'shared/atom_header', feed: feed, items: @articles

  @articles.each do |item|
    render 'shared/atom_item_article', feed: feed, item: item
  end
end
