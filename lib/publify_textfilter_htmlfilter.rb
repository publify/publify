class PublifyApp
  class Textfilter
    class Htmlfilter < TextFilterPlugin
      plugin_display_name 'HTML Filter'
      plugin_description 'Strip HTML tags'

      def self.filtertext(_blog, _content, text, _params)
        text.to_s.gsub('<', '&lt;').gsub('>', '&gt;')
      end
    end
  end
end
