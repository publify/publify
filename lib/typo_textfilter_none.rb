class Typo
  class Textfilter
    class None < TextFilterPlugin::Markup
      plugin_display_name "None"
      plugin_description 'Raw HTML only'

      def self.filtertext(blog,content,text,params)
        text
      end
    end
  end
end