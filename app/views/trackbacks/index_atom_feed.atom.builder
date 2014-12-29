atom_feed do |feed|
  render "shared/atom_header", {feed: feed, items: @trackbacks}

  @trackbacks.each do |trackback|
    render "shared/atom_item_trackback", {feed: feed, item: trackback}
  end
end
