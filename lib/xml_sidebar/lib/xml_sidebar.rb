class XmlSidebar < Sidebar
  display_name "XML Syndication"
  description "RSS and Atom feeds"

  setting :articles,   true,  :input_type => :checkbox
  setting :comments,   true,  :input_type => :checkbox
  setting :trackbacks, false, :input_type => :checkbox
  setting :article_comments, true, :input_type => :checkbox
  setting :category_feeds, false, :input_type => :checkbox
  setting :tag_feeds, false, :input_type => :checkbox

  setting :format, 'atom', :input_type => :radio,
          :choices => [["rss",  "RSS"], ["atom", "Atom"]]

  def format_strip
    strip_format = self.format
    strip_format ||= 'atom'
    strip_format.gsub!(/\d+/,'')
    strip_format.gsub!('1.0', '')
    strip_format.gsub!('2.0', '')
    strip_format
  end

end
