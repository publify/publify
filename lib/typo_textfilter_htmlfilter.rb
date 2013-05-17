class Typo
  class Textfilter
    class Htmlfilter < TextFilterPlugin
      plugin_display_name "HTML Filter"
      plugin_description 'Strip HTML tags'

      def self.filtertext(blog,content,text,params)
        text.to_s.gsub( "<", "&lt;" ).gsub( ">", "&gt;" )
      end
    end
  end
end
