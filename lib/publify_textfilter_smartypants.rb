class PublifyApp
  class Textfilter
    class Smartypants < TextFilterPlugin::PostProcess
      plugin_display_name 'Smartypants'
      plugin_description 'Converts HTML to use publifygraphically correct quotes and dashes'

      def self.filtertext(_blog, _content, text, _params)
        RubyPants.new(text).to_html
      end
    end
  end
end
