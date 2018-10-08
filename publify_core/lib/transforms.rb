# frozen_string_literal: true

# FIXME: Replace with helpers and/or methods provided by Rails
class String
  ACCENTS = { %w(á à â ä ã Ã Ä Â À) => 'a',
              %w(é è ê ë Ë É È Ê) => 'e',
              %w(í ì î ï I Î Ì) => 'i',
              %w(ó ò ô ö õ Õ Ö Ô Ò) => 'o',
              ['œ'] => 'oe',
              ['ß'] => 'ss',
              %w(ú ù û ü U Û Ù) => 'u',
              %w(ç Ç) => 'c' }.freeze

  def to_permalink
    string = self
    ACCENTS.each do |key, value|
      string = string.tr(key.join, value)
    end
    string = string.tr("'", '-')
    string.gsub(/<[^>]*>/, '').to_url
  end

  # Returns a-string-with-dashes when passed 'a string with dashes'.
  # All special chars are stripped in the process
  def to_url
    return if nil?

    s = downcase.tr("\"'", '')
    s = s.gsub(/\P{Word}/, ' ')
    s.strip.tr_s(' ', '-').tr(' ', '-').sub(/^$/, '-')
  end

  def to_title(item, settings, params)
    TitleBuilder.new(self).build(item, settings, params)
  end

  # Strips any html markup from a string
  TYPO_TAG_KEY = TYPO_ATTRIBUTE_KEY = /[\w:_-]+/
  TYPO_ATTRIBUTE_VALUE = /(?:[A-Za-z0-9]+|(?:'[^']*?'|"[^"]*?"))/
  TYPO_ATTRIBUTE = /(?:#{TYPO_ATTRIBUTE_KEY}(?:\s*=\s*#{TYPO_ATTRIBUTE_VALUE})?)/
  TYPO_ATTRIBUTES = /(?:#{TYPO_ATTRIBUTE}(?:\s+#{TYPO_ATTRIBUTE})*)/
  TAG = %r{<[!/?\[]?(?:#{TYPO_TAG_KEY}|--)(?:\s+#{TYPO_ATTRIBUTES})?\s*(?:[!/?\]]+|--)?>}
  def strip_html
    gsub(TAG, '').gsub(/\s+/, ' ').strip
  end
end
