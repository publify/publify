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
        require 'RedCloth'
        RedCloth.new(text).to_html(:textile)
      rescue LoadError => e
        Rails.logger.warn 'You have not RedCloth install. Please install it gem install RedCloth'
        text
      end
    end
  end
end
