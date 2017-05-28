require 'text_filter_plugin'

class PublifyApp
  class Textfilter
    class None < TextFilterPlugin::Markup
      plugin_display_name 'None'
      plugin_description 'Raw HTML only'

      def self.filtertext(text)
        text
      end
    end
  end
end
