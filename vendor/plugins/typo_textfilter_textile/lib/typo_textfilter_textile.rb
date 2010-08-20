class Typo
  class Textfilter
    class Textile < TextFilterPlugin::Markup
      plugin_display_name "Textile"
      plugin_description 'Textile markup language'

      def self.help_text
        %{
See [_why's Textile reference](http://hobix.com/textile/).
}
      end

      def self.filtertext(blog,content,text,params)
        RedCloth.new(text).to_html(:textile)
      end
    end
  end
end
