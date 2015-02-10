class PublifyApp
  class Textfilter
    class None < TextFilterPlugin::Markup
      plugin_display_name 'None'
      plugin_description 'Raw HTML only'

      def self.filtertext(_blog, _content, text, _params)
        text
      end
    end
  end
end
