atom_feed do |feed|
  render "shared/atom_header", {:feed => feed, :items => @comments}

  @comments.each do |item|
    render "shared/atom_item_comment", {:feed => feed, :item => item}
  end
end

