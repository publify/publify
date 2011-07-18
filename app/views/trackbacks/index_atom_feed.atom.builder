atom_feed do |feed|
  render "shared/atom_header", {:feed => feed, :items => @trackbacks}

  @trackbacks.each do |item|
    render "shared/atom_item_trackback", {:feed => feed, :item => item}
  end
end
