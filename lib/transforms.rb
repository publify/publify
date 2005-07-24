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

class String
  # Converts a post title to its-title-using-dashes
  # All special chars are stripped in the process  
  def to_url
    return if self.nil?
    
    result = self.downcase

    # replace quotes by nothing
    result.gsub!(/['"]/, '')

    # strip all non word chars
    result.gsub!(/\W/, ' ')

    # replace all white space sections with a dash
    result.gsub!(/\ +/, '-')

    # trim dashes
    result.gsub!(/(-)$/, '')
    result.gsub!(/^(-)/, '')

    result
  end
end