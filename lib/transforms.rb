# coding: utf-8
class String
  # Returns a-string-with-dashes when passed 'a string with dashes'.
  # All special chars are stripped in the process
  def to_url
    return if self.nil?

    s = self.downcase.tr("\"'", '')
    # Inject correct version-dependent regex using string interpolations
    # since the 1.9 version is invalid for 1.8.
    s = s.gsub(/#{RUBY_VERSION < "1.9" ? '\W' : '\P{Word}'}/, ' ')
    s.strip.tr_s(' ', '-').tr(' ', '-').sub(/^$/, "-")
  end

  # A quick and dirty fix to add 'nofollow' to any urls in a string.
  # Decidedly unsafe, but will have to do for now.
  def nofollowify
    return self if Blog.default.dofollowify
    self.gsub(/<a(.*?)>/i, '<a\1 rel="nofollow">')
  end

  # Strips any html markup from a string
  TYPO_TAG_KEY = TYPO_ATTRIBUTE_KEY = /[\w:_-]+/
  TYPO_ATTRIBUTE_VALUE = /(?:[A-Za-z0-9]+|(?:'[^']*?'|"[^"]*?"))/
  TYPO_ATTRIBUTE = /(?:#{TYPO_ATTRIBUTE_KEY}(?:\s*=\s*#{TYPO_ATTRIBUTE_VALUE})?)/
  TYPO_ATTRIBUTES = /(?:#{TYPO_ATTRIBUTE}(?:\s+#{TYPO_ATTRIBUTE})*)/
  TAG = %r{<[!/?\[]?(?:#{TYPO_TAG_KEY}|--)(?:\s+#{TYPO_ATTRIBUTES})?\s*(?:[!/?\]]+|--)?>}
  def strip_html
    self.gsub(TAG, '').gsub(/\s+/, ' ').strip
  end

end
