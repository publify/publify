# frozen_string_literal: true

class XmlSidebar < SidebarConfiguration
  display_name "XML Syndication"
  description "RSS and Atom feeds"

  setting :articles, true, input_type: :checkbox
  setting :feedback, true, input_type: :checkbox
  setting :article_comments, true, input_type: :checkbox
  setting :tag_feeds, false, input_type: :checkbox

  setting :format, "atom", input_type: :radio, choices: [%w(rss RSS), %w(atom Atom)]

  def format_strip
    strip_format = +format
    strip_format ||= +"atom"
    strip_format.gsub!(/\d+/, "")
    strip_format.gsub!("1.0", "")
    strip_format.gsub!("2.0", "")
    strip_format
  end
end

SidebarRegistry.register_sidebar XmlSidebar
