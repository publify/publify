class XmlSidebar < Sidebar
  display_name _("XML Syndication")
  description "RSS and Atom feeds"

  setting :articles,   true,  :input_type => :checkbox
  setting :comments,   true,  :input_type => :checkbox
  setting :trackbacks, false, :input_type => :checkbox

  setting :format, 'atom', :input_type => :radio,
          :choices => [["rss",  "RSS"], ["atom", "Atom"]]

  def format_strip
    format.gsub(/\d+/,'')
    format.gsub('1.0', '')
    format.gsub('2.0', '')
  end

end
