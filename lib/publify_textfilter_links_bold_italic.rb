class PublifyApp
  class Textfilter
    class LinksBoldItalic < TextFilterPlugin::PostProcess
      plugin_display_name 'Only Links, Bold and Italic tags permitted'
      plugin_description 'Strips out all html other than links, bold and italic tags.'

      def self.filtertext(_, _, text, _)
        sanitize(text, tags: ['a', 'strong', 'b', 'em', 'i'])
      end
    end
  end
end
