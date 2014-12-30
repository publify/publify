class PublifyApp
  class Textfilter
    class OnlyLinks < TextFilterPlugin::PostProcess
      plugin_display_name "Only Links"
      plugin_description 'Strips out all html other than links'

      def self.filtertext(_, _, text, _)
        sanitize(text, tags: ['a'])
      end
    end
  end
end
