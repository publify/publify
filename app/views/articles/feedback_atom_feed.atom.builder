atom_feed do |feed|
  render "shared/atom_header", {:feed => feed, :items => @feedback}

  @feedback.each do |item|
    render "shared/atom_item_#{item.type.downcase}", {:feed => feed, :item => item}
  end
end

