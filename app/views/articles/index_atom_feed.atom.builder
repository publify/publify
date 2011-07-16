atom_feed do |feed|
  render "shared/atom_header", {:feed => feed, :items => @articles}

  @articles.each do |value|
    value.to_atom(feed)
  end
end

