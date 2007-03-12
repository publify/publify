class XmlSidebar < Sidebar
  display_name _("XML Syndication")
  description "RSS and Atom feeds"

  setting :articles,   true,  :input_type => :checkbox
  setting :comments,   true,  :input_type => :checkbox
  setting :trackbacks, false, :input_type => :checkbox

  setting :format, 'rss20', :input_type => :radio,
          :choices => [["rss20",  "RSS 2.0"], ["atom10", "Atom 1.0"]]
end
