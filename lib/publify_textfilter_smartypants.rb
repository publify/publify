class PublifyApp
  class Textfilter
    class Smartypants < TextFilterPlugin::PostProcess
      plugin_display_name 'Smartypants'
      plugin_description 'Converts HTML to use publifygraphically correct quotes and dashes'

      def self.filtertext(text)
        RubyPants.new(text).to_html
      end
    end
  end
end
