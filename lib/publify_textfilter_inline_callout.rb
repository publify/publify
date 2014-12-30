class PublifyApp
  class Textfilter
    class InlineCallout< TextFilterPlugin::MacroPost
      plugin_display_name "Inline Callout"
      plugin_description "Insert an inline callout"

      def self.help_text
        %{
You can use `<publify:inlinecallout>` to display a Ma Says snippet.  Example:

    <publify:inlinecallout url="https://www.moneyadviceservice.org.uk/en/campaigns/saving-for-a-holiday">
      Saving for a Holiday
    </publify:inlinecallout>}
      end

      def self.macrofilter(_, _, attrib, _, text)
        url = attrib['url']

        "<div class=\"snippet inline-callout\">
           <a class=\"inline-callout__text\" href=\"#{url}\">#{text}
             <svg class=\"inline-callout__arrow\" version=\"1.1\" id=\"Layer_1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" x=\"0px\" y=\"0px\" viewBox=\"46.9 -3.6 36 57.1\" enable-background=\"new 46.9 -3.6 36 57.1\" xml:space=\"preserve\">
               <polyline class=\"inline-callout__arrow-path\" stroke-width=\"9\" stroke-miterlimit=\"10\" points=\"50,0 76,25 50,50 \"/>
             </svg>
           </a>
         </div>"
      end
    end
  end
end
