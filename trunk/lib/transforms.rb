def nofollowify(text)
  text.gsub(/<\s*a\s*(.+?)>/i, '<a \1 rel="nofollow">')
end

def strip_html(text)
  attribute_key = /[\w:_-]+/
  attribute_value = /(?:[A-Za-z0-9]+|(?:'[^']*?'|"[^"]*?"))/
  attribute = /(?:#{attribute_key}(?:\s*=\s*#{attribute_value})?)/
  attributes = /(?:#{attribute}(?:\s+#{attribute})*)/
  tag_key = attribute_key
  tag = %r{<[!/?\[]?(?:#{tag_key}|--)(?:\s+#{attributes})?\s*(?:[!/?\]]+|--)?>}
  text.gsub(tag, '').gsub(/\s+/, ' ').strip
end

