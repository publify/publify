class PublifyApp
  class Textfilter
    class TextileAndMarkdown < TextFilterPlugin::Markup
      plugin_display_name 'Textile with Markdown'
      plugin_description 'Textile and Markdown markup languages'

      def self.filtertext(_blog, _content, text, _params)
        RedCloth.new(text).to_html
      end
    end
  end
end
