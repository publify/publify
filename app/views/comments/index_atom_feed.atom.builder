atom_feed do |feed|
  render "shared/atom_header", {feed: feed, items: @comments}

  @comments.each do |comment|
    render "shared/atom_item_comment", {feed: feed, item: comment}
  end
end

