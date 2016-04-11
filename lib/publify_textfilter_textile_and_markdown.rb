class PublifyApp
  class Textfilter
    class TextileAndMarkdown < TextFilterPlugin::Markup
      plugin_display_name 'Textile with Markdown'
      plugin_description 'Textile and Markdown markup languages'

      def self.filtertext(text)
        RedCloth.new(text).to_html
      end
    end
  end
end
