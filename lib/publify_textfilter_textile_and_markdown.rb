# frozen_string_literal: true

class PublifyApp
  class Textfilter
    class TextileAndMarkdown < TextFilterPlugin::Markup
      plugin_display_name "Textile with Markdown (Deprecated)"
      plugin_description "Textile and Markdown markup languages"

      def self.filtertext(text)
        ActiveSupport::Deprecation.warn \
          "Use of the Textile with Markdown filter is deprecated"
        RedCloth.new(text).to_html
      end
    end
  end
end
