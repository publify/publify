json.array! @articles do |item|
  json.partial! "shared/json_item_article", {:json => json, :item => item}
end
